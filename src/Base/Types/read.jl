abstract SeqRead

type FastaRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
end

type FastqRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
	strand::ASCIIString
	quality::Quality
end

Base.length(read::SeqRead) = length(read.sequence)

Base.getindex(read::FastqRead, i::Int64) = (getindex(read.sequence, i), getindex(read.quality, i))
Base.getindex(read::FastqRead, r::UnitRange{Int64}) = FastqRead(read.name, getindex(read.sequence, r), read.strand, getindex(read.quality, r))
Base.getindex(read::FastqRead, indx::AbstractArray{Int64,1}) = FastqRead(read.name, getindex(read.sequence, indx), read.strand, getindex(read.quality, indx))
Base.reverse(read::FastqRead) = FastqRead(read.name, reverse(read.sequence), read.strand, reverse(read.quality))
complement(read::FastqRead) = FastqRead(read.name, complement(read.sequence), read.strand, read.quality)
reverse_complement(read::FastqRead) = FastqRead(read.name, reverse_complement(read.sequence), read.strand, reverse(read.quality))

Base.getindex(read::FastaRead, i::Int64) = getindex(read.sequence, i)
Base.getindex(read::FastaRead, r::UnitRange{Int64}) = FastaRead(read.name, getindex(read.sequence, r))
Base.getindex(read::FastaRead, indx::AbstractArray{Int64,1}) = FastaRead(read.name, getindex(read.sequence, indx))
Base.reverse(read::FastaRead) = FastaRead(read.name, reverse(read.sequence))
complement(read::FastaRead) = FastaRead(read.name, complement(read.sequence))
reverse_complement(read::FastaRead) = FastaRead(read.name, reverse_complement(read.sequence))

-(read::FastqRead) = reverse(read)
!(read::FastqRead) = complement(read)
~(read::FastqRead) = reverse_complement(read)
-(read::FastaRead) = reverse(read)
!(read::FastaRead) = complement(read)
~(read::FastaRead) = reverse_complement(read)

type FastqPair
	# read1 and read2 are considered as different directions
	read1::FastqRead
	read2::FastqRead

	# template length, if it's not calculated, it is set as -1
	template_length::Int
	# overlap length, if it's not calculated, it is set as -1
	overlap_length::Int
end

function FastqPair(read1::FastqRead, read2::FastqRead)
	return FastqPair(read1, read2, -1, -1)
end
Return-Path: <linux-kernel-owner+w=401wt.eu-S1750950AbXBQS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950AbXBQS1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXBQS1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:27:20 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:43308 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXBQS1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:27:18 -0500
Message-ID: <45D748E2.7020800@scarlet.be>
Date: Sat, 17 Feb 2007 18:26:42 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Tejun Heo <htejun@gmail.com>, Luming Yu <luming.yu@gmail.com>,
       Alan Cox <alan@redhat.com>, Ioan Ionita <opslynx@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be> <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com> <45D0D133.8070801@scarlet.be> <45D1F6E4.2080102@scarlet.be> <20070213195729.GN7584@csclub.uwaterloo.ca> <45D6E821.5070305@scarlet.be> <20070217145959.GI7582@csclub.uwaterloo.ca>
In-Reply-To: <20070217145959.GI7582@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> 
> Hmm, readcd was trying to read 279884 blocks, while cdrecord said it
> wrote 279882 blocks.
> 
yes and seems to be always the same:
with new burned cd I got:
# ll /MultiCd/cd060213.iso
-rwxr-xr-x 1 root root 3213312 Feb 13  2006 /MultiCd/cd060213.iso

i.e. 3213312/2048 == 1569

while:
readcd dev=/dev/hdd f=- | md5sum
Read  speed:  1059 kB/s (CD   6x, DVD  0x).
Write speed:   353 kB/s (CD   2x, DVD  0x).
Capacity: 1571 Blocks = 3142 kBytes = 3 MBytes = 3 prMB
Sectorsize: 2048 Bytes
Copy from SCSI (1,1,0) disk to file '-'
end:      1571
Errno: 0 (Success), read_g1 scsi sendcmd: no error
CDB:  28 00 00 00 06 00 00 00 23 00
status: 0x2 (CHECK CONDITION)
Sense Bytes:
Sense Key: 0xFFFFFFFF [], Segment 0
Sense Code: 0x00 Qual 0x00 (no additional sense information) Fru 0x0
Sense flags: Blk 0 (not valid)
cmd finished after 0.014s timeout 40s
readcd: Success. Cannot read source disk
readcd: Retrying from sector 1536.

so always Capacity == original image size + 2 ?

[snip]
> 
> There always seems to have been any issue with reading blocks from a cd
> getting broken by the kernel doing readahead and getting failures by
> trying to read past the end of the disc even though the user never asked
> it to.  Sometimes your size just happens to hit a safe block size so the
> readahead doesn't break.
> 
btw this tips:
readcd dev=/dev/hdd sectors=0-1569 f=- | md5sum
Read  speed:  1059 kB/s (CD   6x, DVD  0x).
Write speed:   353 kB/s (CD   2x, DVD  0x).
Capacity: 1571 Blocks = 3142 kBytes = 3 MBytes = 3 prMB
Sectorsize: 2048 Bytes
Copy from SCSI (1,1,0) disk to file '-'
end:      1569
addr:     1569 cnt: 33
Time total: 5.436sec
Read 3138.00 kB at 577.3 kB/sec.
6a1248783a21722816b972aa9bae9d5e  -

(adding sectors=0-1569 : 1569 being the size of the original image)

seems to work fine
# md5sum /MultiCd/cd060213.iso
6a1248783a21722816b972aa9bae9d5e  /MultiCd/cd060213.iso

>> is the same wrong results.
>>
>> mmm I always used successfully dd method at my office with scsi cdrom drive 
>> (even for bootable disk).
> 
> Well it seems some disks can be read that way, others can not.
> 
I would be curious to read same cd on scsi cdrom (at the office)?

Cheers,
	Joel	

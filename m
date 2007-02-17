Return-Path: <linux-kernel-owner+w=401wt.eu-S965202AbXBQLeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202AbXBQLeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965203AbXBQLeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:34:16 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:43885 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965202AbXBQLeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:34:15 -0500
Message-ID: <45D6E821.5070305@scarlet.be>
Date: Sat, 17 Feb 2007 11:33:53 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Tejun Heo <htejun@gmail.com>, Luming Yu <luming.yu@gmail.com>,
       Alan Cox <alan@redhat.com>, Ioan Ionita <opslynx@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be> <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be> <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com> <45D0D133.8070801@scarlet.be> <45D1F6E4.2080102@scarlet.be> <20070213195729.GN7584@csclub.uwaterloo.ca>
In-Reply-To: <20070213195729.GN7584@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lennart,

Lennart Sorensen wrote:
> On Tue, Feb 13, 2007 at 05:35:32PM +0000, Joel Soete wrote:
>> A small update:
>> your patch also works against 2.6.20
>>
>> but seems that open the door to numerous other pb:
>> 1/ pb to burn cd:
>> # md5sum cd060213.iso
>> 6a1248783a21722816b972aa9bae9d5e  cd060213.iso
>>
>> # ll cd060213.iso
>> -rwxr-xr-x 1 root root 3213312 Feb 13  2006 cd060213.iso
>>
>> # dd if=/dev/sr0 bs=1 count=3213312 | md5sum
>> dd: reading `/dev/sr0': Input/output error
>> 0337e9846d17779945c5c252d4f897f0  -
>> 3129344+0 records in
>> 3129344+0 records out
>> 3129344 bytes (3.1 MB) copied, 36.6963 seconds, 85.3 kB/s
>>
>> eventhought cdrecord seems to be successfull???
> 
> Has that ever worked by any method?

Yes here was some test made some time ago (not so far):
 >> On Sun January 8 2006 09:28, you wrote:
 > cdrecord: No write mode specified.
 > cdrecord: Asuming -tao mode.
 > cdrecord: Future versions of cdrecord may have different drive dependent
 > defaults.
 > cdrecord: Continuing in 5 seconds...
 > cdrecord: Warning: Running on Linux-2.6.15-686
 > cdrecord: There are unsettled issues with Linux-2.5 and newer.
 > cdrecord: If you have unexpected problems, please try Linux-2.4 or Solaris.
 > scsidev: '/dev/hdb'
 > devname: '/dev/hdb'
 > scsibus: -2 target: -2 lun: -2
 > Warning: Open by 'devname' is unintentional and not supported.
 > Linux sg driver version: 3.5.27
 > cdrecord: Warning: using inofficial version of libscg (ubuntu-0.8ubuntu1
 > '@(#)scsitransp.c      1.91 04/06/17 Copyright 1988,1995,2000-2004 J.
 > Schilling').
 > SCSI buffer size: 64512
 > cdrecord: Asked for SCSI I/O buffer size 64512 bytes, could only get 20480.
 > Cdrecord-Clone 2.01.01a03 (i686-pc-linux-gnu) Copyright (C) 1995-2005
 > Joerg Schilling
 > NOTE: this version of cdrecord is an inofficial (modified) release of
 > cdrecord
 >       and thus may have bugs that are not present in the original version.
 >       Please send bug reports and support requests to
 > <cdrtools@packages.debian.org>.
 >       The original author should not be bothered with problems of this
 > version.
 >
 > TOC Type: 1 = CD-ROM
 > Using libscg version 'ubuntu-0.8ubuntu1'.
 > atapi: 1
 > Device type    : Removable CD-ROM
 > Version        : 0
 > Response Format: 1
 > Vendor_info    : 'PHILIPS '
 > Identifikation : 'CDD3610 CD-R/RW '
 > Revision       : '3.09'
 > Device seems to be: Generic mmc CD-RW.
 > Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
 > Driver flags   : MMC SWABAUDIO
 > Supported modes: TAO PACKET RAW/R16
 > Drive buf size : 786432 = 768 KB
 > FIFO size      : 4194304 = 4096 KB
 > Track 01: data   546 MB
 > Total size:      627 MB (62:11.78) = 279884 sectors
 > Lout start:      628 MB (62:13/59) = 279884 sectors
 > Current Secsize: 2048
 >   ATIP start of lead in:  -11637 (97:26/63)
 >   ATIP start of lead out: 337350 (75:00/00)
 > Disk type:    Phase change
 > Manuf. index: 3
 > Manufacturer: CMC Magnetics Corporation
 > Blocks total: 337350 Blocks current: 337350 Blocks remaining: 57466
 > Starting to write CD/DVD at speed 2 in real TAO mode for single session.
 > Waiting for reader process to fill input buffer ... input buffer ready.
 > Performing OPC...
 > Starting new track at sector: 0
 > Track 01:  546 of  546 MB written (fifo 100%) [buf  94%]   2.0x.
 > Track 01: Total bytes read/written: 573198336/573198336 (279882 sectors).
 > Writing  time: 1878.179s
 > Average write speed   2.0x.
 > Min drive buffer fill was 94%
 > Fixating...
 > Fixating time:  167.622s
 > cdrecord: fifo had 27989 puts and 27989 gets.
 > cdrecord: fifo was 0 times empty and 27757 times full, min fill was 98%.
 >
[snip]
 >  # readcd dev=/dev/hdb f=- | md5sum
 > Read  speed:  1059 kB/s (CD   6x, DVD  0x).
 > Write speed:   353 kB/s (CD   2x, DVD  0x).
 > Capacity: 279884 Blocks = 559768 kBytes = 546 MBytes = 573 prMB
 > Sectorsize: 2048 Bytes
 > Copy from SCSI (0,1,0) disk to file '-'
 > end:    279884
 > readcd: Success. read_g1: scsi sendcmd: no error
 > CDB:  28 00 00 04 45 48 00 00 04 00
 > status: 0x2 (CHECK CONDITION)
 > Sense Bytes:
 > Sense Key: 0xFFFFFFFF [], Segment 0
 > Sense Code: 0x00 Qual 0x00 (no additional sense information) Fru 0x0
 > Sense flags: Blk 0 (not valid)
 > cmd finished after 0.005s timeout 40s
 > readcd: Success. Cannot read source disk
 > readcd: Retrying from sector 279880.
 > ....~~-~~~+~~~-~~~+~~~-~~~+~
 >
[snip]
 > # ll
 > total 1150848
 > [...]
 > -rw-r----- 1 root root   604082176 Jan 15 12:22 hppa-cvs-20060115.iso
 >
 > i.e. Block_Number = 604082176 / 2048 = 294962
 >
 >
 > # md5sum hppa-cvs-20060115.iso
 > 1141489a8b914daff5cca790882fe277  hppa-cvs-20060115.iso
 >
 >  # dd bs=2048 count=294962 if=/dev/hdb  | md5sum
 > 294962+0 records in
 > 294962+0 records out
 > 604082176 bytes (604 MB) copied, 676.972 seconds, 892 kB/s
 > 1141489a8b914daff5cca790882fe277  -
 >
 > ;<)
more same method here:
# dd if=/dev/hdd bs=2048 count=1569 | md5sum
dd: reading `/dev/hdd': Input/output error
1528+0 records in
1528+0 records out
3129344 bytes (3.1 MB) copied, 10.1961 seconds, 307 kB/s
0337e9846d17779945c5c252d4f897f0  -

is the same wrong results.

>  I have always had to use readcd
> along with passing the correct number of sectors on the CD to get a
> proper matching image.  dd always seems to end up reading some junk past
> the end of the disc.
> 
mmm I always used successfully dd method at my office with scsi cdrom drive (even for bootable disk).

>> 2/ (but that should be much more related to scsi api) sdcXX > sdc15 doesn't 
>> works ;-(
>> # sfdisk -l /dev/sdc
>>
>> Disk /dev/sdc: 1826 cylinders, 255 heads, 63 sectors/track
>> Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0
>>
>>    Device Boot Start     End   #cyls    #blocks   Id  System
>> /dev/sdc1   *      0+    195     196-   1574338+   b  W95 FAT32
>> /dev/sdc2        196    1825    1630   13092975    5  Extended
>> /dev/sdc3          0       -       0          0    0  Empty
[snip]
>> /dev/sdc23       881+   1533     653-   5245191   83  Linux
>> /dev/sdc24      1795    1825      31     249007+  83  Linux
> 
> I have to ask: What are all those partitions?
> 
It came from an age (see >> brw-rw---- 1 root disk 8, 32 Dec  1  2001 /dev/sdc)
when 15Gb disk was enough to test severall Linux distro ;-)
At the same time I was also working with a distro runing on a x486 100Mhz, a few ram and 128Mb of disk ;-)

>> # mount /dev/sdc22 /4free
>> mount: /dev/sdc22 is not a valid block device
>>
>> # ll /dev/sdc*
>> brw-rw---- 1 root disk 8, 32 Dec  1  2001 /dev/sdc
>> brw-rw---- 1 root disk 8, 33 Dec  1  2001 /dev/sdc1
>> brw-rw---- 1 root disk 8, 42 Dec  1  2001 /dev/sdc10
>> brw-rw---- 1 root disk 8, 43 Dec  1  2001 /dev/sdc11
>> brw-rw---- 1 root disk 8, 44 Dec  1  2001 /dev/sdc12
>> brw-rw---- 1 root disk 8, 45 Dec  1  2001 /dev/sdc13
>> brw-rw---- 1 root disk 8, 46 Dec  1  2001 /dev/sdc14
>> brw-rw---- 1 root disk 8, 47 Dec  1  2001 /dev/sdc15
>> brw-r--r-- 1 root root 8, 48 Feb 13 16:26 /dev/sdc16
>> brw-r--r-- 1 root root 8, 49 Feb 13 16:26 /dev/sdc17
>> brw-r--r-- 1 root root 8, 50 Feb 13 16:26 /dev/sdc18
>> brw-r--r-- 1 root root 8, 51 Feb 13 16:27 /dev/sdc19
>> brw-rw---- 1 root disk 8, 34 Dec  1  2001 /dev/sdc2
>> brw-r--r-- 1 root root 8, 52 Feb 13 16:27 /dev/sdc20
>> brw-r--r-- 1 root root 8, 53 Feb 13 16:27 /dev/sdc21
>> brw-r--r-- 1 root root 8, 54 Feb 13 16:27 /dev/sdc22
>> brw-r--r-- 1 root root 8, 55 Feb 13 16:27 /dev/sdc23
>> brw-r--r-- 1 root root 8, 56 Feb 13 16:27 /dev/sdc24
>> brw-rw---- 1 root disk 8, 35 Dec  1  2001 /dev/sdc3
>> brw-rw---- 1 root disk 8, 36 Dec  1  2001 /dev/sdc4
>> brw-rw---- 1 root disk 8, 37 Dec  1  2001 /dev/sdc5
>> brw-rw---- 1 root disk 8, 38 Dec  1  2001 /dev/sdc6
>> brw-rw---- 1 root disk 8, 39 Dec  1  2001 /dev/sdc7
>> brw-rw---- 1 root disk 8, 40 Dec  1  2001 /dev/sdc8
>> brw-rw---- 1 root disk 8, 41 Dec  1  2001 /dev/sdc9
> 
> Hmm, using udev?  Any chance udev incorrectly doesn't check for going
> past the end of the block devices allowed (each scsi device has 16
> minors assigned, which gives you 15 partitions per device).  Last device
> for sdc is 8,47.  8,48 (your sdc16) is actually sdd.
> 
Ah ok I wasn't aware.

Thanks for help,
	Joel

Return-Path: <linux-kernel-owner+w=401wt.eu-S964965AbXBLPWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965AbXBLPWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964969AbXBLPWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:22:36 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:47587 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964965AbXBLPWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:22:35 -0500
X-Greylist: delayed 4813 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 10:22:35 EST
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: linux-kernel@vger.kernel.org
Subject: SATA-performance: Linux vs. FreeBSD
Date: Mon, 12 Feb 2007 15:02:17 +0100
User-Agent: KMail/1.8
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702121502.17130.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I did some performance tests that made me really wonder:

My Hardware:
Asus P5LD2 board with Intel i945P chipset, ICH7R southbridge
CPU Intel Core 2 Duo E6300 at 1.86 GHz, 2 MB Cache
1 GB RAM
My Software:
OpenSuSE 10.2 with Linux kernel 2.6.18, x86-64 architecture
FreeBSD 6.2

Testdrives:
1. HDD: Seagate ST3250820AS RPM 7200.9, 8 MB Cache, 250 GB, SATA-II
   (Harddisk Drive)
2. SSD: Adtron AF25FB, 27GB, SATA Revision 1.0a (Solid State Disk)

What I did:
I wrote blocks of 1 MB size to file. Each 1 GB I made a fsync and took the 
time. For those tests with filesystems I wrote files of 1 GB size, otherwise 
I just wrote to the raw device.

Results: -1-

Test					OpenSuSE(AHCI)			FreeBSD(AHCI)
---------------------------------------------------------------------------------------------------------------------------------------
SSD(vfat 25GB)			41+/-2 MB/s at 4-10%		15+/-0 MB/s at 2% CPU
SSD(raw  25GB) 		26+/-1 MB/s at 4-10% CPU	48+/-0 MB/s at 1% CPU
SSD(ext3 25GB)		39+/-5 MB/s at 10-15% CPU	34+/-0 MB/s at 14% CPU
SSD(ext2 25GB)		42+/-1 MB/s at 10-15% CPU	32+/-0 MB/s at 10% CPU
---------------------------------------------------------------------------------------------------------------------------------------

Test					OpenSuSE (AHCI off)		FreeBSD (AHCI off)
---------------------------------------------------------------------------------------------------------------------------------------
SSD(vfat 25GB)			22+/-4 MB/s at 6-19% CPU	--
SSD(raw  25GB)		33+/-4 MB/s at 7-14% CPU	41+/-0 MB/s at 1% CPU
SSD(ext2 25GB)		27+/-6 MB/s at 6-14% CPU	--
---------------------------------------------------------------------------------------------------------------------------------------

Question 1:
Can anybody explain to me, why writing to a SATA-I device with AHCI consumes 
so much CPU time using Linux, while it takes almost no CPU time on FreeBSD 
6.2 ? Especially comparing values of writing to the raw device?

Question 2:
Can anybody explain to me, why writing to a solid state disk (a kind of memory 
that always has the same constant bandwidth) has such big standard errors in 
writing rate using Linux (between 1 to 6 MB/s error) while FreeBSD gives an 
almost constant writing rate (as one would expect it for a SSD) ?

Question 3:
Why is writing to a raw device in Linux slower than using e.g. ext2 ? And why 
is Linux writing rate much lower (-12.5 % for the best case) compared to 
writing rate of FreeBSD?

Question 4:
When writing to the SATA-II HDD Linux is around 10% slower than FreeBSD when 
using ext3, but around as fast as FreeBSD when writing raw. Why?


How can I improve the speed of Linux,
Thanks for advices

Martin

PS: part of my testcode:

  int fd=open(fileName, O_WRONLY | O_CREAT | O_TRUNC, 0666);
  (void)gettimeofday(&start, 0);
  for (long bl=0; bl < blocksPerGigaByte; ++bl)
    write(fd, block, blockSize);
  fsync(fd);
  (void)gettimeofday(&ende, 0);

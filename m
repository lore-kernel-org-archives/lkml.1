Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXKNI4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXKNI4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXKNI4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:56:31 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2765 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXKNI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:56:29 -0500
Date: Wed, 14 Nov 2007 08:56:01 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc2-mm1 -- mkfs failing on variety of fs types
Message-ID: <20071114085549.GG12003@shadowen.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We seem to have some general problem with mkfs for all filesystems.
I am seeing this across at least three test systems although
most are unable to compile this kernel :(, even with the hotfix.
Basically, all mkfs operations for any filsystem type are failing,
ext2 reports this as "short write", various others are mentioning
pwrite and pwrite64 returning bad things:

ext2: Could not write 8 blocks in inode table starting at 851970:
	Attempt to write block from filesystem resulted in short
	write

reiserfs: bwrite: write 4096 bytes returned -1 (block=851968,
	dev=3): No space left on device

xfs: mkfs.xfs: pwrite64 failed: No space left on device

Nothing is reported in dmesg at the time as far as I can tell.  From the
ext2 log I would swear we get this error on a block number far below that
which is reported written successfully, though I cannot say I trust mkfs.

Nothing obvious has changed pwrite or block/* to my eye, so heck knows
where this is coming from.  2.6.24-rc2 works on these same systems as
goes the latest 2.6.24-rc2-git5.

Full mkfs output below.

-apw

*** elm3b6, x86_64:

mke2fs 1.37 (21-Mar-2005)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
1465920 inodes, 2929854 blocks
146492 blocks (5.00%) reserved for the super user
First data block=0
90 block groups
32768 blocks per group, 32768 fragments per group
16288 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208

mkfs.ext2: Attempt to write block from filesystem resulted in short write while zeroing block 2929824 at end of filesystem
Writing inode tables: 
Could not write 8 blocks in inode table starting at 851970: Attempt to write block from filesystem resulted in short write
===
mkfs.jfs version 1.1.7, 22-Jul-2004
The specified disk did not finish formatting.
===
mkfs.reiserfs 3.6.19 (2003 www.namesys.com)
[...]
Guessing about desired format.. Kernel 2.6.24-rc2-mm1-autokern1 is running.
Format 3.6 with standard journal
Count of blocks on the device: 2929840
Number of blocks consumed by mkreiserfs formatting process: 8301
Blocksize: 4096
Hash function used to sort names: "r5"
Journal Size 8193 blocks (first block 18)
Journal Max transaction length 1024
inode generation number: 0
UUID: c759e218-681b-4891-b4c4-33466d4eb4f0
Initializing journal - 0%....20%....40%....60%....80%....100%
bwrite: write 4096 bytes returned -1 (block=851968, dev=3): No space left on device
===
mkfs.xfs: pwrite64 failed: No space left on device
meta-data=/dev/sdb2              isize=256    agcount=16, agsize=183115 blks
         =                       sectsz=512  
data     =                       bsize=4096   blocks=2929840, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


*** elm3b239, x86_64:

mke2fs 1.38 (30-Jun-2005)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
2410624 inodes, 4819500 blocks
240975 blocks (5.00%) reserved for the super user
First data block=0
148 block groups
32768 blocks per group, 32768 fragments per group
16288 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000

mkfs.ext2: Attempt to write block from filesystem resulted in short write while zeroing block 4819472 at end of filesystem
Writing inode tables: 
Could not write 8 blocks in inode table starting at 655362: Attempt to write block from filesystem resulted in short write


*** pSeries-101, ppc64

mke2fs 1.38 (30-Jun-2005)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
1281696 inodes, 2560000 blocks
128000 blocks (5.00%) reserved for the super user
First data block=0
79 block groups
32768 blocks per group, 32768 fragments per group
16224 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

mkfs.ext2: Attempt to write block from filesystem resulted in short write while zeroing block 2559984 at end of filesystem
Writing inode tables: 
Could not write 8 blocks in inode table starting at 491522: Attempt to write block from filesystem resulted in short write


*** gekko-lp1, ppc64

mke2fs 1.38 (30-Jun-2005)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
1224000 inodes, 2443880 blocks
122194 blocks (5.00%) reserved for the super user
First data block=0
75 block groups
32768 blocks per group, 32768 fragments per group
16320 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

mkfs.ext2: Attempt to write block from filesystem resulted in short write while zeroing block 2443856 at end of filesystem
Writing inode tables: 
Could not write 8 blocks in inode table starting at 360450: Attempt to write block from filesystem resulted in short write
===
mkfs.xfs: pwrite64 failed: No space left on device
meta-data=/dev/sda7              isize=256    agcount=16, agsize=152742 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2443872, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
===
mkfs.reiserfs 3.6.19 (2003 www.namesys.com)
[...]
Guessing about desired format.. Kernel 2.6.24-rc2-mm1-autokern1 is running.
Format 3.6 with standard journal
Count of blocks on the device: 2443872
Number of blocks consumed by mkreiserfs formatting process: 8286
Blocksize: 4096
Hash function used to sort names: "r5"
Journal Size 8193 blocks (first block 18)
Journal Max transaction length 1024
inode generation number: 0
UUID: e9aa2dc4-dfc3-47e8-865b-693f28eac2e5
Initializing journal - 0%....20%....40%....60%....80%....100%
bwrite: write 4096 bytes returned -1 (block=360448, dev=3): No space left on device

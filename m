Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXF2Hky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXF2Hky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764850AbXF2Hkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:40:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:35905 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764973AbXF2Hkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DW1aQ2hT11xHLjjD+OUV4g7pnu7ITnXZYy7P4H+mwNTJGyOj9By7iaZVF85G1q7xLJ65R/TI/lrBDteLHFdCECw9JH8jJ5EZx1v/8GN/fI3mTSVhUeW58S11ZdKXHS1FjNC0B2q2AYJmjZN8IlgcD303/1ZavvHLRaTVD3SNBns=
Message-ID: <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>
Date: Fri, 29 Jun 2007 13:10:40 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: jdi@l4x.org, hjk@linutronix.de, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Fwd: Mounting MMC card
In-Reply-To: <200706282210.23770.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
	 <46840A66.1010901@drzeus.cx> <200706282210.23770.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

>
> # mount /dev/mmcblk0p0 /mnt/mmc
> mount: mounting /dev/mmcblk0p0 on /mnt/mmc failed
>
>   I have tried with /dev/mmcblk0p0, mmcblk0p1,etc. But of no use. How

>Try to mount mmcblk0 and/or try fdisk and look at the partition
>table. dmesg output would also be helpful (after the failed mount).
>
>Jan

    I have tried mounting mmcblk0. But I get the same error from
mount. I have pasted the dmesg log at the end of the mail.


>You should check:
>
>* Is the driver for your MMC actually loaded?
>* Did it initialize correctly? Does it find your MMC card?

   As far as I have seen the log, the device gets probed properly.
Also the kernel detects the MMC card when inserted. So there must be
no problem with the driver loading.

>* Is support for the file system on the MMC in your kernel?

  Yes. There is support for MMC card in my kernel. The following is
from the .config file.

#
# MMC/SD Card support
#
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_BLOCK=y
CONFIG_MMC_IMX=y



>* /dev/mmcblk0p0 and /mnt/mmc really exist? (sorry, but...)

  Yes they do. I have created the /dev/mmcblk0, /dev/mmcblk0p0,
/dev/mmcblk0p1, /dev/mmcblk0p2, /dev/mmcblk0p3, /dev/mmcblk0p4 entries
using mknod. Also I have created the /mnt and /mnt/mmc directories.

>
>Check the output of dmesg for messages from the mmc driver.
>
>Hans

   I have checked the log and it is attached to the end of the mail.
The log contains debug messages for removing and inserting the MMC
card. But nothing specific relating to mount. Can you interpret
anything more from it?

>Have you checked that your device nodes are correct? Since you use busybox I
>assume the system is too lightweight to run udev.

    Yes. I have checked the device nodes. They are fine for MMC. (I
have made them form what I got on the internet. BTW can anybody tell
me how can I find the corresponding major and minor number for my
device driver? This MMC driver is from Microcross. I have put the
device nodes as 254,0 - which are generic.).

>I run udev on an arm system, it costs you about 200kBytes,
>and saves you all the trouble with creating device files.
>Note that you don't need any rules files. If you want to write
>rules, you can even implement a poor-man's hotplug without HAL.
>If you can afford 200k, use udev.

   I have seen the udev page. But I am a bit skeptic about
implementing it with my kernelas this kernel is from Microcross -
customized for CSB535FS board. I want to try udev only as my last
option.


Please help me resolve this issue. I have been on it for a week now.

Thanks a lot,
Midhun.



The dmesg log:
============

<7>jffs2_add_physical_node_ref(): Node at 0x160300(2), size 0x124
<7>jffs2_write_dnode wrote node at 0x00160300(2) with dsize 0x269,
csize 0xde, node_crc 0x7b52763e, data_crc 0x5a16f8e5, totlen
0x00000122
<7>[JFFS2 DBG] (673) jffs2_add_full_dnode_to_inode: adding node
0x00-0x269 @0x00160300 on flash, newfrag *c2d05fe0
<7>Obsoleting node at 0x001602bc of len 0x44: <7>Wasting
<7>obliterating obsoleted node at 0x001602bc
<7>jffs2_complete_reservation()
<7>jffs2_thread_should_wake(): nr_free_blocks 22, nr_erasing_blocks 0,
dirty_size 0x2f1e4: no
<7>increasing writtenlen by 617
<7>jffs2_commit_write() returning 0
<7>jffs2_lookup()
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 27
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #27
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #27 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #27
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x087618(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @00087618: ver 1, offset 0x00,
dsize 0x07, csize 0x07
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #27 were
read, the highest version is 1, latest_mctime 3269877536, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x087618(3), range 0-7.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x07, ver 1
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: symlink's target
'busybox' cached
<7>jffs2_read_inode() returning
<7>jffs2_follow_link(): target path is 'busybox'
<7>jffs2_follow_link(): target path is 'busybox'
<6>imx-mmc imx-mmc.0: card removed
<6>imx-mmc imx-mmc.0: card inserted
<7>jffs2_setattr(): ino #353
<7>jffs2_reserve_space(): Requested 0x44 bytes
<7>jffs2_reserve_space(): alloc sem got
<7>jffs2_do_reserve_space(): Giving 0x1fbdc bytes at 0x160424
<7>jffs2_add_physical_node_ref(): Node at 0x160424(2), size 0x44
<7>jffs2_write_dnode wrote node at 0x00160424(2) with dsize 0x0, csize
0x0, node_crc 0x93cbd6de, data_crc 0x00000000, totlen 0x00000044
<7>[JFFS2 DBG] (673) jffs2_truncate_fragtree: truncating fragtree to
0x00000000 bytes
<7>Obsoleting node at 0x00160300 of len 0x124: <7>Wasting
<7>obliterating obsoleted node at 0x00160300
<7>jffs2_complete_reservation()
<7>jffs2_thread_should_wake(): nr_free_blocks 22, nr_erasing_blocks 0,
dirty_size 0x2f1e4: no
<7>jffs2_prepare_write()
<7>jffs2_read_inode_range: ino #353, range 0x00000000-0x00001000
<7>Filling non-frag hole from 0-4096
<7>end prepare_write(). pg->flags 209
<7>jffs2_commit_write(): ino #353, page at 0x0, range 0-620, flags 209
<7>jffs2_write_inode_range(): Ino #353, ofs 0x0, len 0x26c
<7>jffs2_reserve_space(): Requested 0xc4 bytes
<7>jffs2_reserve_space(): alloc sem got
<7>jffs2_do_reserve_space(): Giving 0x1fb98 bytes at 0x160468
<7>calling deflate with avail_in 608, avail_out 608
<7>deflate returned with avail_in 0, avail_out 400, total_in 608, total_out 208
<7>calling deflate with avail_in 12, avail_out 400
<7>deflate returned with avail_in 0, avail_out 393, total_in 620, total_out 215
<7>zlib compressed 620 bytes into 221
<7>jffs2_add_physical_node_ref(): Node at 0x160468(2), size 0x124
<7>jffs2_write_dnode wrote node at 0x00160468(2) with dsize 0x26c,
csize 0xdd, node_crc 0xbb276af8, data_crc 0x6463d190, totlen
0x00000121
<7>[JFFS2 DBG] (673) jffs2_add_full_dnode_to_inode: adding node
0x00-0x26c @0x00160468 on flash, newfrag *c2d05fe0
<7>Obsoleting node at 0x00160424 of len 0x44: <7>Wasting
<7>obliterating obsoleted node at 0x00160424
<7>jffs2_complete_reservation()
<7>jffs2_thread_should_wake(): nr_free_blocks 22, nr_erasing_blocks 0,
dirty_size 0x2f1e4: no
<7>increasing writtenlen by 620
<7>jffs2_commit_write() returning 0
<7>jffs2_follow_link(): target path is 'busybox'
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 191
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #191
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #191 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #191
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x08e2ac(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @0008e2ac: ver 1, offset 0x00,
dsize 0x02, csize 0x02
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #191 were
read, the highest version is 1, latest_mctime 3269873816, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x08e2ac(3), range 0-2.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x02, ver 1
<7>Reading device numbers from flash
<7>Node read from 0008e2ac: node_crc 660cfdce, calculated CRC
660cfdce. dsize 2, csize 2, offset 0, buf c2e47ce0
<7>jffs2_read_inode() returning
<7>jffs2_readdir() for dir_i #3
<7>Dirent 0: ".", ino #3
<7>Dirent 1: "..", ino #1
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 362
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #362
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #362 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #362
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x1f533c(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @001f533c: ver 1, offset 0x00,
dsize 0x02, csize 0x02
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #362 were
read, the highest version is 1, latest_mctime 3269873940, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x1f533c(3), range 0-2.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x02, ver 1
<7>Reading device numbers from flash
<7>Node read from 001f533c: node_crc 51f8a8f5, calculated CRC
51f8a8f5. dsize 2, csize 2, offset 0, buf c2e47d10
<7>jffs2_read_inode() returning
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 363
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #363
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #363 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #363
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x1f5554(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @001f5554: ver 1, offset 0x00,
dsize 0x02, csize 0x02
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #363 were
read, the highest version is 1, latest_mctime 3269874064, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x1f5554(3), range 0-2.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x02, ver 1
<7>Reading device numbers from flash
<7>Node read from 001f5554: node_crc 5deb85e2, calculated CRC
5deb85e2. dsize 2, csize 2, offset 0, buf c2e47d10
<7>jffs2_read_inode() returning
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 364
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #364
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #364 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #364
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x1f576c(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @001f576c: ver 1, offset 0x00,
dsize 0x02, csize 0x02
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #364 were
read, the highest version is 1, latest_mctime 3269874188, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x1f576c(3), range 0-2.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x02, ver 1
<7>Reading device numbers from flash
<7>Node read from 001f576c: node_crc ce82a7a6, calculated CRC
ce82a7a6. dsize 2, csize 2, offset 0, buf c2e47d10
<7>jffs2_read_inode() returning
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 365
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #365
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #365 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #365
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x1f5980(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @001f5980: ver 1, offset 0x00,
dsize 0x02, csize 0x02
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #365 were
read, the highest version is 1, latest_mctime 3269874312, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x1f5980(3), range 0-2.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x02, ver 1
<7>Reading device numbers from flash
<7>Node read from 001f5980: node_crc 4423aa5b, calculated CRC
4423aa5b. dsize 2, csize 2, offset 0, buf c2e47d10
<7>jffs2_read_inode() returning
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 361
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #361
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #361 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #361
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x1f5130(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @001f5130: ver 1, offset 0x00,
dsize 0x02, csize 0x02
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #361 were
read, the highest version is 1, latest_mctime 3269874436, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x1f5130(3), range 0-2.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x02, ver 1
<7>Reading device numbers from flash
<7>Node read from 001f5130: node_crc 55539f75, calculated CRC
55539f75. dsize 2, csize 2, offset 0, buf c2e47d10
<7>jffs2_read_inode() returning
<7>jffs2_readdir() for dir_i #3
<7>jffs2_readdir() for dir_i #1
<7>Dirent 0: ".", ino #1
<7>Dirent 1: "..", ino #1
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 355
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #355
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #355 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #355
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x0f29dc(2).
<7>[JFFS2 DBG] (673) jffs2_add_fd_to_list: add dirent "mmc", ino #356
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x0f2824(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @000f2824: ver 2, offset 0x00,
dsize 0x00, csize 0x00
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #355 were
read, the highest version is 3, latest_mctime 534, mctime_ver 3.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
2, phys offset 0x0f2824(3), range 0-0.
<7>jffs2_read_inode() returning
<7>jffs2_readdir() for dir_i #1
<7>jffs2_readdir() for dir_i #355
<7>Dirent 0: ".", ino #355
<7>Dirent 1: "..", ino #1
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 356
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #356
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #356 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #356
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x0f2a08(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @000f2a08: ver 2, offset 0x00,
dsize 0x00, csize 0x00
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #356 were
read, the highest version is 2, latest_mctime 3269874684, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
2, phys offset 0x0f2a08(3), range 0-0.
<7>jffs2_read_inode() returning
<7>jffs2_readdir() for dir_i #355
<7>jffs2_setattr(): ino #353
<7>jffs2_reserve_space(): Requested 0x44 bytes
<7>jffs2_reserve_space(): alloc sem got
<7>jffs2_do_reserve_space(): Giving 0x1fa74 bytes at 0x16058c
<7>jffs2_add_physical_node_ref(): Node at 0x16058c(2), size 0x44
<7>jffs2_write_dnode wrote node at 0x0016058c(2) with dsize 0x0, csize
0x0, node_crc 0x17517d14, data_crc 0x00000000, totlen 0x00000044
<7>[JFFS2 DBG] (673) jffs2_truncate_fragtree: truncating fragtree to
0x00000000 bytes
<7>Obsoleting node at 0x00160468 of len 0x124: <7>Wasting
<7>obliterating obsoleted node at 0x00160468
<7>jffs2_complete_reservation()
<7>jffs2_thread_should_wake(): nr_free_blocks 22, nr_erasing_blocks 0,
dirty_size 0x2f1e4: no
<7>jffs2_prepare_write()
<7>jffs2_read_inode_range: ino #353, range 0x00000000-0x00001000
<7>Filling non-frag hole from 0-4096
<7>end prepare_write(). pg->flags 209
<7>jffs2_commit_write(): ino #353, page at 0x0, range 0-652, flags 209
<7>jffs2_write_inode_range(): Ino #353, ofs 0x0, len 0x28c
<7>jffs2_reserve_space(): Requested 0xc4 bytes
<7>jffs2_reserve_space(): alloc sem got
<7>jffs2_do_reserve_space(): Giving 0x1fa30 bytes at 0x1605d0
<7>calling deflate with avail_in 640, avail_out 640
<7>deflate returned with avail_in 0, avail_out 434, total_in 640, total_out 206
<7>calling deflate with avail_in 12, avail_out 434
<7>deflate returned with avail_in 0, avail_out 424, total_in 652, total_out 216
<7>zlib compressed 652 bytes into 222
<7>jffs2_add_physical_node_ref(): Node at 0x1605d0(2), size 0x124
<7>jffs2_write_dnode wrote node at 0x001605d0(2) with dsize 0x28c,
csize 0xde, node_crc 0xb28a4850, data_crc 0x35b0a0f9, totlen
0x00000122
<7>[JFFS2 DBG] (673) jffs2_add_full_dnode_to_inode: adding node
0x00-0x28c @0x001605d0 on flash, newfrag *c2d05fe0
<7>Obsoleting node at 0x0016058c of len 0x44: <7>Wasting
<7>obliterating obsoleted node at 0x0016058c
<7>jffs2_complete_reservation()
<7>jffs2_thread_should_wake(): nr_free_blocks 22, nr_erasing_blocks 0,
dirty_size 0x2f1e4: no
<7>increasing writtenlen by 652
<7>jffs2_commit_write() returning 0
<7>jffs2_follow_link(): target path is 'busybox'
<7>jffs2_follow_link(): target path is 'busybox'
<7>jffs2_lookup()
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 334
<7>[JFFS2 DBG] (679) jffs2_do_read_inode: read inode #334
<7>[JFFS2 DBG] (679) jffs2_do_read_inode_internal: ino #334 nlink is 1
<7>[JFFS2 DBG] (679) jffs2_get_inode_nodes: ino #334
<7>[JFFS2 DBG] (679) jffs2_get_inode_nodes: read 40 bytes at 0x0f0220(3).
<7>[JFFS2 DBG] (679) read_more: read more 28 bytes
<7>[JFFS2 DBG] (679) read_dnode: dnode @000f0220: ver 1, offset 0x00,
dsize 0x0e, csize 0x0e
<7>[JFFS2 DBG] (679) jffs2_get_inode_nodes: nodes of inode #334 were
read, the highest version is 1, latest_mctime 3269875428, mctime_ver
0.
<7>[JFFS2 DBG] (679) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x0f0220(3), range 0-14.
<7>[JFFS2 DBG] (679) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x0e, ver 1
<7>[JFFS2 DBG] (679) jffs2_do_read_inode_internal: symlink's target
'../bin/busybox' cached
<7>jffs2_read_inode() returning
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_lookup()
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_follow_link(): target path is '../bin/busybox'
<7>jffs2_lookup()
<7>jffs2_lookup()
<7>jffs2_read_inode(): inode->i_ino == 39
<7>[JFFS2 DBG] (673) jffs2_do_read_inode: read inode #39
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: ino #39 nlink is 1
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: ino #39
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: read 40 bytes at 0x087bcc(3).
<7>[JFFS2 DBG] (673) read_more: read more 28 bytes
<7>[JFFS2 DBG] (673) read_dnode: dnode @00087bcc: ver 1, offset 0x00,
dsize 0x07, csize 0x07
<7>[JFFS2 DBG] (673) jffs2_get_inode_nodes: nodes of inode #39 were
read, the highest version is 1, latest_mctime 3269875056, mctime_ver
0.
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: consider node ver
1, phys offset 0x087bcc(3), range 0-7.
<7>[JFFS2 DBG] (673) jffs2_add_older_frag_to_fragtree: insert fragment
0x00-0x07, ver 1
<7>[JFFS2 DBG] (673) jffs2_do_read_inode_internal: symlink's target
'busybox' cached
<7>jffs2_read_inode() returning
<7>jffs2_follow_link(): target path is 'busybox'
<7>jffs2_follow_link(): target path is 'busybox'

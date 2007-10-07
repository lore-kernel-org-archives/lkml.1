Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXJGBKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXJGBKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 21:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXJGBKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 21:10:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41313 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbXJGBKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 21:10:06 -0400
X-Sasl-enc: 8LCTSLrNjbob95vVV/cf+dkMerVZNxgZ/JtiGVSFRX3/ 1191719402
Message-ID: <470831E6.4030704@fastmail.co.uk>
Date: Sun, 07 Oct 2007 09:09:58 +0800
From: Max Waterman <davidmaxwaterman+kernel@fastmail.co.uk>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: XFS internal error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just had an XFS error occur while deleting some directory
hierarchy. I hope this is the correct place to report it.

It essentially shutdown the file system, and a reboot seemed to return
everything to normal.

This is in syslog :

> Oct  6 23:40:33 jeeves kernel: xfs_da_do_buf: bno 16777216
> Oct  6 23:40:33 jeeves kernel: dir: inode 2095141277
> Oct  6 23:40:33 jeeves kernel: Filesystem "md2": XFS internal error xfs_da_do_buf(1) at line 1994 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff889b2de4
> Oct  6 23:40:33 jeeves kernel: 
> Oct  6 23:40:33 jeeves kernel: Call Trace:
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889b2a21>] :xfs:xfs_da_do_buf+0x2da/0x633
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889bafb3>] :xfs:xfs_dir2_leafn_lookup_int+0x2c6/0x44b
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889bb013>] :xfs:xfs_dir2_leafn_lookup_int+0x326/0x44b
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889d721a>] :xfs:xfs_trans_log_buf+0x55/0x81
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889b2de4>] :xfs:xfs_da_read_buf+0x24/0x29
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889b988e>] :xfs:xfs_dir2_node_removename+0x23a/0x43a
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889b988e>] :xfs:xfs_dir2_node_removename+0x23a/0x43a
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8106c632>] find_lock_page+0x26/0xa2
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889a5521>] :xfs:xfs_bmap_last_offset+0xcd/0xdb
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889b5189>] :xfs:xfs_dir_removename+0x102/0x110
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889e0de6>] :xfs:kmem_zone_alloc+0x52/0x9f
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889c7c98>] :xfs:xfs_inode_item_init+0x1e/0x7a
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889e050e>] :xfs:xfs_remove+0x2a9/0x437
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109d0f5>] __link_path_walk+0x16e/0xd9c
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889e6da7>] :xfs:xfs_vn_unlink+0x21/0x4f
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889c2310>] :xfs:xfs_iunlock+0x57/0x79
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889db297>] :xfs:xfs_access+0x3d/0x46Oct  6 23:40:33 jeeves kernel:  [<ffffffff889e6eaa>] :xfs:xfs_vn_permission+0x14/0x19
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109b7e5>] permission+0xaf/0xf7
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109c583>] vfs_unlink+0xbc/0x102
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109e4ef>] do_unlinkat+0xaa/0x144
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff81009c71>] tracesys+0x71/0xda
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff81009cd5>] tracesys+0xd5/0xda
> Oct  6 23:40:33 jeeves kernel: 
> Oct  6 23:40:33 jeeves kernel: Filesystem "md2": XFS internal error xfs_trans_cancel at line 1132 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff889e0668
> Oct  6 23:40:33 jeeves kernel: 
> Oct  6 23:40:33 jeeves kernel: Call Trace:
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889d622d>] :xfs:xfs_trans_cancel+0x5b/0xf1
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889e0668>] :xfs:xfs_remove+0x403/0x437
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109d0f5>] __link_path_walk+0x16e/0xd9c
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889e6da7>] :xfs:xfs_vn_unlink+0x21/0x4f
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889c2310>] :xfs:xfs_iunlock+0x57/0x79
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889db297>] :xfs:xfs_access+0x3d/0x46
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff889e6eaa>] :xfs:xfs_vn_permission+0x14/0x19
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109b7e5>] permission+0xaf/0xf7
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109c583>] vfs_unlink+0xbc/0x102Oct  6 23:40:33 jeeves kernel:  [<ffffffff8109e4ef>] do_unlinkat+0xaa/0x144
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff81009c71>] tracesys+0x71/0xda
> Oct  6 23:40:33 jeeves kernel:  [<ffffffff81009cd5>] tracesys+0xd5/0xda
> Oct  6 23:40:33 jeeves kernel: 
> Oct  6 23:40:33 jeeves kernel: xfs_force_shutdown(md2,0x8) called from line 1133 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff889d624b
> Oct  6 23:40:33 jeeves kernel: Filesystem "md2": Corruption of in-memory data detected.  Shutting down filesystem: md2
> Oct  6 23:40:33 jeeves kernel: Please umount the filesystem, and rectify the problem(s)Oct  6 23:43:53 jeeves shutdown[18347]: shutting down for system reboot

I am fairly sure there is nothing I can do about this, but I thought it
prudent to mention it. Searching turned up some similar issues, but they
seem related to a previous kernel version and claimed to be fixed in
subsequent versions.

> Linux jeeves.mydomain 2.6.22.7-57.fc6 #1 SMP Fri Sep 21 19:45:12 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux

The array is a little 'unorthodox', if that matters.

It's using 4 on-board(nforce) sata drives and 4 PCI IDE drives :

> /dev/md2:
>         Version : 00.90.03
>   Creation Time : Sat Aug  6 10:18:41 2005
>      Raid Level : raid5
>      Array Size : 976804480 (931.55 GiB 1000.25 GB)
>     Device Size : 195360896 (186.31 GiB 200.05 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun Oct  7 09:05:43 2007
>           State : clean
>  Active Devices : 6
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 2
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : 15bfec75:595ac793:0914f8ee:862effd8
>          Events : 0.9341058
> 
>     Number   Major   Minor   RaidDevice State
>        0      33        0        0      active sync   /dev/hde
>        1      34        0        1      active sync   /dev/hdg
>        2      56        0        2      active sync   /dev/hdi
>        3       8       32        3      active sync   /dev/sdc
>        4       8       48        4      active sync   /dev/sdd
>        5       8       80        5      active sync   /dev/sdf
> 
>        6       8       64        -      spare   /dev/sde
>        7      57        0        -      spare   /dev/hdk

Max.

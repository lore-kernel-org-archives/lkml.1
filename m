Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbYBOJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbYBOJfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYBOJf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:35:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbYBOJfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:35:25 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: <joakim.tjernlund@transmode.se>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <004601c86fa2$201a78d0$1fa9580a@swcenter.sec.samsung.co.kr> <1203065237.5419.74.camel@gentoo-jocke.transmode.se> <005001c86fb0$b9bc6d00$1fa9580a@swcenter.sec.samsung.co.kr> <1203065951.5419.84.camel@gentoo-jocke.transmode.se>
Subject: RE: Abnormal behavior with JFFS2 on latest kernel
Date: Fri, 15 Feb 2008 18:35:20 +0900
Organization: infradead
Message-ID: <007d01c86fb6$1705db90$1fa9580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <1203065951.5419.84.camel@gentoo-jocke.transmode.se>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-index: AchvsQ7neq0Ue+kBS1SqnxyAjSoYMgABNVNg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Nope, the patch is probably named
> "[JFFS2] Stop erasing blocks when rebooting."
> 

No it's same; we have to find another one.

KB  reclen   write rewrite    read    reread
          131072       4    3420    3683    15320    15341
          131072       8INFO: task iozone:227 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
iozone        D c021685c     0   227    222
[<c02164c0>] (schedule+0x0/0x41c) from [<c0216314>] (__down+0xa4/0xfc)
[<c0216270>] (__down+0x0/0xfc) from [<c021620c>] (__down_failed+0xc/0x20)
 r8:c3815c70 r7:00000000 r6:c3815c30 r5:00000000 r4:00004078
[<c01182b8>] (jffs2_write_begin+0x0/0x3c0) from [<c00660cc>] (generic_file_buff)
[<c0065fbc>] (generic_file_buffered_write+0x0/0x65c) from [<c0066e58>] (__gener)
[<c0066908>] (__generic_file_aio_write_nolock+0x0/0x580) from [<c0066f00>] (gen)
[<c0066e88>] (generic_file_aio_write+0x0/0xf4) from [<c008870c>] (do_sync_write)
[<c008865c>] (do_sync_write+0x0/0xf4) from [<c0088810>] (vfs_write+0xc0/0xf8)
 r8:c0020224 r7:c3d5df78 r6:41200000 r5:c3d9a220 r4:00002000
[<c0088750>] (vfs_write+0x0/0xf8) from [<c0088904>] (sys_write+0x48/0x74)
 r7:00000004 r6:c3d9a220 r5:00000000 r4:04078000
[<c00888bc>] (sys_write+0x0/0x74) from [<c001fa20>] (ret_fast_syscall+0x0/0x2c)
 r6:00000000 r5:00002000 r4:00004000
INFO: task jffs2_gcd_mtd4:257 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jffs2_gcd_mtd D c021685c     0   257      2
[<c02164c0>] (schedule+0x0/0x41c) from [<c0216da8>] (io_schedule+0x2c/0x48)
[<c0216d7c>] (io_schedule+0x0/0x48) from [<c0063b54>] (sync_page+0x50/0x5c)
 r5:00000000 r4:c3f07cb0
[<c0063b04>] (sync_page+0x0/0x5c) from [<c02170f8>] (__wait_on_bit_lock+0x60/0x)
[<c0217098>] (__wait_on_bit_lock+0x0/0x94) from [<c006469c>] (__lock_page+0x88/)
[<c0064614>] (__lock_page+0x0/0x98) from [<c00654ac>] (read_cache_page_async+0x)
 r5:00000000 r4:c0320ea0
[<c006536c>] (read_cache_page_async+0x0/0x1b8) from [<c0124fcc>] (jffs2_gc_fetc)
[<c0124fa0>] (jffs2_gc_fetch_page+0x0/0x64) from [<c0121758>] (jffs2_garbage_co)
 r4:0407a000
[<c0120cac>] (jffs2_garbage_collect_live+0x0/0x11ac) from [<c01225a4>] (jffs2_g)
[<c0121e58>] (jffs2_garbage_collect_pass+0x0/0x844) from [<c0123cb0>] (jffs2_ga)
[<c0123b88>] (jffs2_garbage_collect_thread+0x0/0x168) from [<c003de0c>] (do_exi)
 r8:00000000 r7:00000000 r6:00000000 r5:00000000 r4:00000000

Thank you,
Kyungmin Park


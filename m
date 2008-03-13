Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYCMNnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYCMNnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYCMNmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:42:55 -0400
Received: from 205.158.150.226.ptr.us.xo.net ([205.158.150.226]:2221 "EHLO
	mail.exegy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952AbYCMNmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:42:54 -0400
Thread-Index: AciFECLtRf2y+i3NTKKdUxQw0RkibQ==
X-Ninja-AntiSpoofing: spoofed
Message-ID: <47D92F5C.8050705@exegy.com>
Date: Thu, 13 Mar 2008 08:42:52 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-xfs@oss.sgi.com>
Subject: spinlock lockup in 2.6.24-* and 2.6.25-rc5
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4133
Importance: normal
X-OriginalArrivalTime: 13 Mar 2008 13:42:53.0136 (UTC) FILETIME=[22E36D00:01C88510]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mar 13 08:09:23 airraid kernel: [  755.061181] XFS mounting filesystem sdk1
Mar 13 08:16:46 airraid kernel: [ 1197.357903] BUG: spinlock lockup on 
CPU#1, ShiftGen/4711, ffff81000001b715
Mar 13 08:16:46 airraid kernel: [ 1197.357929] Pid: 4711, comm: ShiftGen 
Not tainted 2.6.25-RC5 #2
Mar 13 08:16:46 airraid kernel: [ 1197.357941]
Mar 13 08:16:46 airraid kernel: [ 1197.357941] Call Trace:
Mar 13 08:16:46 airraid kernel: [ 1197.357977]  [<ffffffff8117b7cf>] 
_raw_spin_lock+0xcf/0xf6
Mar 13 08:16:46 airraid kernel: [ 1197.357991]  [<ffffffff81071a59>] 
rmqueue_bulk+0x31/0x91
Mar 13 08:16:46 airraid kernel: [ 1197.358003]  [<ffffffff81072fe1>] 
get_page_from_freelist+0x2c4/0x590
Mar 13 08:16:46 airraid kernel: [ 1197.358024]  [<ffffffff81073343>] 
__alloc_pages+0x6d/0x302
Mar 13 08:16:46 airraid kernel: [ 1197.358037]  [<ffffffff8106e227>] 
__grab_cache_page+0x36/0x72
Mar 13 08:16:46 airraid kernel: [ 1197.358050]  [<ffffffff810b58c2>] 
block_write_begin+0x38/0xca
Mar 13 08:16:46 airraid kernel: [ 1197.358067]  [<ffffffff81138cec>] 
xfs_vm_write_begin+0x22/0x27
Mar 13 08:16:46 airraid kernel: [ 1197.358250]  [<ffffffff8113931c>] 
xfs_get_blocks+0x0/0xe
Mar 13 08:16:46 airraid kernel: [ 1197.358424]  [<ffffffff8106eebd>] 
generic_file_buffered_write+0x150/0x624
Mar 13 08:16:47 airraid kernel: [ 1197.358600]  [<ffffffff812d38e3>] 
_spin_lock_irqsave+0x9/0xe
Mar 13 08:16:47 airraid kernel: [ 1197.358776]  [<ffffffff8113fde4>] 
xfs_write+0x54f/0x793
Mar 13 08:16:47 airraid kernel: [ 1197.358947]  [<ffffffff8114e197>] 
dummy_file_permission+0x0/0x3
Mar 13 08:16:47 airraid kernel: [ 1197.359122]  [<ffffffff81095344>] 
do_sync_write+0xc9/0x10c
Mar 13 08:16:47 airraid kernel: [ 1197.359293]  [<ffffffff8104c706>] 
autoremove_wake_function+0x0/0x2e
Mar 13 08:16:47 airraid kernel: [ 1197.359464]  [<ffffffff8103471b>] 
finish_task_switch+0x37/0x82
Mar 13 08:16:47 airraid kernel: [ 1197.359637]  [<ffffffff812d214d>] 
thread_return+0x3d/0x84
Mar 13 08:16:47 airraid kernel: [ 1197.359811]  [<ffffffff81095aea>] 
vfs_write+0xc6/0x14f
Mar 13 08:16:47 airraid kernel: [ 1197.359978]  [<ffffffff81096040>] 
sys_write+0x45/0x6e
Mar 13 08:16:47 airraid kernel: [ 1197.360148]  [<ffffffff8100c0cc>] 
tracesys+0xdc/0xe1
Mar 13 08:16:47 airraid kernel: [ 1197.360316]
Mar 13 08:38:55 airraid syslogd 1.4.1: restart.

rc5 does it too.
Linux airraid 2.6.25-RC5 #2 SMP Wed Mar 12 09:50:59 CDT 2008 x86_64 
x86_64 x86_64 GNU/Linux


100% reproducible spin lock lockup on x86_64, 16GB to 32GB RAM, Centos 5.1
Tyan 3992 or SuperMicro H8DMi-2 motherboard, dual 2222 3.0GHz opterons.
Dual LSI-8888ELP SAS controllers (MegaRaid) into 32 external Seagate
500GB ES 7200.10 sata drives, and 8 internal Seagate 1000GB ES 7200.11 
drives.
All drives in 4 drive raid-0 sets. ShiftGen is a small disk write utility.
XFS xfsprogs-2.9.4-1.el5.centos

The system handles 1,410MB/Sec write rates (256KB stripes, 256KB writes)
Under 2.6.23 without major issues (soft timeouts reported by the LSI).
Under 2.6.24-0 and 2.6.24-3 the system spin lock lockups in XFS
with 5 minutes. The disk partitions are corrupted (access to them under 
other kernels
panics and shuts down the partitions). A complete mkfs.xfs is required 
to "fix" the partitions.
Without spinlock_debug enabled, the system just dies (at about 800MB/Sec 
write rates).
~7KB of /var/log/message data is available on request.

Berkley

Mar 12 08:14:27 airraid kernel: [ 1139.846276] BUG: spinlock lockup on 
CPU#1, ShiftGen/4830, ffff81000001b715
Mar 12 08:14:27 airraid kernel: [ 1139.846304] Pid: 4830, comm: ShiftGen 
Not tainted 2.6.24-exegy #1
Mar 12 08:14:27 airraid kernel: [ 1139.846315]
Mar 12 08:14:27 airraid kernel: [ 1139.846316] Call Trace:
Mar 12 08:14:27 airraid kernel: [ 1139.846346]  [<ffffffff8117b7cf>] 
_raw_spin_lock+0xcf/0xf6
Mar 12 08:14:27 airraid kernel: [ 1139.846360]  [<ffffffff81071a59>] 
rmqueue_bulk+0x31/0x91
Mar 12 08:14:27 airraid kernel: [ 1139.846372]  [<ffffffff81072fe1>] 
get_page_from_freelist+0x2c4/0x590
Mar 12 08:14:27 airraid kernel: [ 1139.846388]  [<ffffffff81073343>] 
__alloc_pages+0x6d/0x302
Mar 12 08:14:27 airraid kernel: [ 1139.846401]  [<ffffffff8106e227>] 
__grab_cache_page+0x36/0x72
Mar 12 08:14:27 airraid kernel: [ 1139.846414]  [<ffffffff810b58c2>] 
block_write_begin+0x38/0xca
Mar 12 08:14:27 airraid kernel: [ 1139.846429]  [<ffffffff81138cec>] 
xfs_vm_write_begin+0x22/0x27
Mar 12 08:14:36 airraid kernel: [ 1139.846610]  [<ffffffff8113931c>] 
xfs_get_blocks+0x0/0xe
Mar 12 08:14:36 airraid kernel: [ 1139.846783]  [<ffffffff8106eebd>] 
generic_file_buffered_write+0x150/0x624
Mar 12 08:14:36 airraid kernel: [ 1139.846964]  [<ffffffff812d38f3>] 
_spin_lock_irqsave+0x9/0xe
Mar 12 08:14:36 airraid kernel: [ 1139.847148]  [<ffffffff8113fde4>] 
xfs_write+0x54f/0x793
Mar 12 08:14:36 airraid kernel: [ 1139.847332]  [<ffffffff81095344>] 
do_sync_write+0xc9/0x10c
Mar 12 08:14:36 airraid kernel: [ 1139.847508]  [<ffffffff8104c706>] 
autoremove_wake_function+0x0/0x2e
Mar 12 08:14:36 airraid kernel: [ 1139.847678]  [<ffffffff8103471b>] 
finish_task_switch+0x37/0x82
Mar 12 08:14:36 airraid kernel: [ 1139.847850]  [<ffffffff812d215d>] 
thread_return+0x3d/0x84
Mar 12 08:14:36 airraid kernel: [ 1139.848020]  [<ffffffff81095aea>] 
vfs_write+0xc6/0x14f
Mar 12 08:14:36 airraid kernel: [ 1139.848190]  [<ffffffff81096040>] 
sys_write+0x45/0x6e
Mar 12 08:14:36 airraid kernel: [ 1139.848364]  [<ffffffff8100c0cc>] 
tracesys+0xdc/0xe1
Mar 12 08:14:36 airraid kernel: [ 1139.848532]

Note: on the Tyan 3992, they system corrupts kernel memory at those 
write rates :-)
The SuperMicro does ok. 2.6.23 lives, 2.6.22 locks up without 
spinlock_debug, but
functions fine (no reported errors) with spinlock_debug enabled.
2.6.23 also has spinlock_debug enabled.




-- 

// E. F. Berkley Shands, MSc//

** Exegy Inc.**

349 Marshall Road, Suite 100

St. Louis , MO  63119

Direct:  (314) 218-3600 X450

Cell:  (314) 303-2546

Office:  (314) 218-3600

Fax:  (314) 218-3601

 

The Usual Disclaimer follows...
 
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYG3GlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYG3GlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYG3GlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:41:05 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:37788 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYG3GlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:41:03 -0400
From: hooanon05@yahoo.co.jp
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: bug? 2.6.26-rc8-mm1, corrupted dcache
Date: Wed, 30 Jul 2008 15:40:28 +0900
Message-ID: <9886.1217400028@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

A filesystem stress test script racer.sh caused a problem in
2.6.26-rc8-mm1. I am not sure it is caused by some changes to memory
management or handling dentry in proc_flush_task_mnt().
Is this problem already known and fixed?

- 2.6.26-rc8-mm1, no extra modules, no outer patch.
- racer.sh was introduced by Andreas Dilger in
  http://marc.info/?l=linux-kernel&m=120518906530609&w=2
- While I changed the script a little, I don't think it affected the
  result.
- If .config is necessary, I will post it later.


Junjiro Okajima


BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<c01949ad>] __d_lookup+0x64/0x1f2
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/net/lo/operstate
Modules linked in: nfs rtc ide_cd_mod cdrom evdev

Pid: 29643, comm: mv Not tainted (2.6.26-rc8-mm1jrousD #36)
EIP: 0060:[<c01949ad>] EFLAGS: 00010292 CPU: 0
EIP is at __d_lookup+0x64/0x1f2
EAX: 00000027 EBX: 6b6b6b6b ECX: c04672f8 EDX: 00000000
ESI: 00000006 EDI: c3401920 EBP: c1407dbc ESP: c1407d68
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mv (pid: 29643, ti=c1406000 task=c2de30b0 task.ti=c1406000)
Stack: c0420081 c2de32a4 000073cb 00000001 c340199c 00000006 c2f96006 6b6b6b6b 
       c3401920 c360f6f8 00000000 c1407da8 c1407e2c c3810f68 c1407e40 00000006 
       cbb0569d c2f96006 c2f9600c c1407e2c c1407f04 c1407de4 c018a5c1 c1407e40 
Call Trace:
 [<c018a5c1>] ? do_lookup+0x1e/0x1a0
 [<c021842a>] ? security_inode_permission+0x3a/0x43
 [<c018c366>] ? __link_path_walk+0x766/0xe29
 [<c02369e4>] ? debug_smp_processor_id+0x28/0xcc
 [<c013e3bf>] ? trace_hardirqs_off+0xb/0xd
 [<c036bf49>] ? add_preempt_count+0x4a/0x8c
 [<c036beb2>] ? sub_preempt_count+0x62/0xaf
 [<c018cd8a>] ? do_path_lookup+0x12e/0x210
 [<c018ca62>] ? path_walk+0x39/0x75
 [<c018cccd>] ? do_path_lookup+0x71/0x210
 [<c018da5c>] ? __path_lookup_intent_open+0x44/0x99
 [<c018db35>] ? path_lookup_open+0x21/0x27
 [<c018ddc5>] ? do_filp_open+0x90/0x7c5
 [<c02369e4>] ? debug_smp_processor_id+0x28/0xcc
 [<c036bf49>] ? add_preempt_count+0x4a/0x8c
 [<c013e426>] ? put_lock_stats+0x27/0x38
 [<c018106f>] ? get_unused_fd_flags+0xc7/0xe0
 [<c036beb2>] ? sub_preempt_count+0x62/0xaf
 [<c0369798>] ? _spin_unlock+0x41/0x4d
 [<c01810e6>] ? do_sys_open+0x5e/0xf3
 [<c0232a84>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c01811c7>] ? sys_open+0x23/0x2b
 [<c0103009>] ? sysenter_past_esp+0x6a/0xa5
 =======================
Code: 0d 38 99 4a c0 d3 e8 31 c3 23 1d 34 99 4a c0 01 db 01 db 03 1d 3c 99 4a c0 e8 1e 3a fc ff 8b 03 89 c3 85 c0 75 37 e9 20 01 00 00 <8b> 03 0f 18 00 90 8d 43 d4 89 45 d0 8d 83 d4 94 94 94 3d ff 00 
EIP: [<c01949ad>] __d_lookup+0x64/0x1f2 SS:ESP 0068:c1407d68



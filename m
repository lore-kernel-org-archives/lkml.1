Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZFLPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZFLPlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZFLPlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:41:05 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:48021 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755163AbZFLPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:41:01 -0400
X-SpamScore: -20
X-BigFish: VPS-20(z21eW39eeh6f5iz98dR11e2K4cd6ka1d3kzz1202hzzz32i6bh17ch61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL4U7L-02-I9D-01
Date: Fri, 12 Jun 2009 17:39:06 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Tony Vroon <tony@vroon.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/smp.c:369
	smp_call_function_many+0x52/0x1b3() [2.6.30-01557-gb640f04]
Message-ID: <20090612153906.GI12431@alberich.amd.com>
References: <1244753567.3768.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1244753567.3768.2.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Jun 2009 15:39:59.0046 (UTC) FILETIME=[0B063660:01C9EB74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 09:52:47PM +0100, Tony Vroon wrote:
> This one is new to me:
   ...
> ------------[ cut here ]------------
> WARNING: at kernel/smp.c:369 smp_call_function_many+0x52/0x1b3()
   ...
> ---[ end trace 4eaa2a86a8e2da22 ]---
> start_kernel(): bug: interrupts were enabled *very* early, fixing it

Same here with v2.6.30-2327-g8ebf975, e.g.

Jun 16 04:07:35 polonium ------------[ cut here ]------------
Jun 16 04:07:35 polonium WARNING: at kernel/smp.c:369 smp_call_function_many+0x\
52/0x1b3()
Jun 16 04:07:35 polonium Hardware name: Dinar
Jun 16 04:07:35 polonium Modules linked in:
Jun 16 04:07:35 polonium Pid: 0, comm: swapper Not tainted 2.6.30-numa-sched-fi\
xup-02332-g8892f68 #1
Jun 16 04:07:35 polonium Call Trace:
Jun 16 04:07:35 polonium [<ffffffff8105a07b>] ? smp_call_function_many+0x52/0x1\
b3
Jun 16 04:07:35 polonium [<ffffffff8105a07b>] ? smp_call_function_many+0x52/0x1\
b3
Jun 16 04:07:35 polonium [<ffffffff8103b415>] ? warn_slowpath_common+0x77/0xa3
Jun 16 04:07:35 polonium [<ffffffff8108d1ae>] ? do_ccupdate_local+0x0/0x2a
Jun 16 04:07:35 polonium [<ffffffff8105a07b>] ? smp_call_function_many+0x52/0x1\
b3
Jun 16 04:07:35 polonium [<ffffffff8108d1ae>] ? do_ccupdate_local+0x0/0x2a
Jun 16 04:07:35 polonium [<ffffffff8108d1ae>] ? do_ccupdate_local+0x0/0x2a
Jun 16 04:07:35 polonium [<ffffffff8105a1fc>] ? smp_call_function+0x20/0x24
Jun 16 04:07:35 polonium [<ffffffff8103f945>] ? on_each_cpu+0x10/0x22
Jun 16 04:07:35 polonium [<ffffffff8108f024>] ? do_tune_cpucache+0xee/0x43d
Jun 16 04:07:35 polonium [<ffffffff8108f518>] ? enable_cpucache+0x5d/0x9d
Jun 16 04:07:35 polonium [<ffffffff81695faf>] ? kmem_cache_init+0x3f7/0x451
Jun 16 04:07:35 polonium [<ffffffff810d6092>] ? kclist_add+0x18/0x36
Jun 16 04:07:35 polonium [<ffffffff8168f047>] ? mem_init+0x152/0x15a
Jun 16 04:07:35 polonium [<ffffffff8167fa06>] ? start_kernel+0x1a4/0x2b7
Jun 16 04:07:35 polonium [<ffffffff8167f354>] ? x86_64_start_kernel+0xe5/0xeb
Jun 16 04:07:35 polonium ---[ end trace 4eaa2a86a8e2da22 ]---
Jun 16 04:07:35 polonium start_kernel(): bug: interrupts were enabled *very* ea\
rly, fixing it

and it's followed by Oopses when I am trying to log in via network, e.g.

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff811c7c9f>] pty_chars_in_buffer+0x14/0x40
PGD 2320b8067 PUD 234929067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:13.2/usb2/2-6/2-6.2/serial
CPU 0
Modules linked in:
Pid: 5312, comm: sshd Tainted: G        W  2.6.30-numa-sched-fixup-02332-g8892f\
68 #1 Dinar
RIP: 0010:[<ffffffff811c7c9f>]  [<ffffffff811c7c9f>] pty_chars_in_buffer+0x14/0\
x40
RSP: 0018:ffff8802330bd9a8  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88023518d000 RCX: ffffffff815263db
RDX: ffff8802319ec6c0 RSI: ffff88023518d188 RDI: ffff880234e23000
RBP: ffff88023518d000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000286 R11: ffffffff811c7c8b R12: ffff880232953700
R13: ffff880232953740 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fa6b23756f0(0000) GS:ffff880028034000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000233008000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sshd (pid: 5312, threadinfo ffff8802330bc000, task ffff880235f86210)
Stack:
 0000000000000000 ffffffff811c343d 0000000000000046 0000000000000000
 ffff88023518d000 ffff880232953740 ffff8802355567c0 ffffffff811c0050
 0000000000000200 0000000000000000 ffff880232953740 0000000000000000
Call Trace:
 [<ffffffff811c343d>] ? n_tty_poll+0x10d/0x130
 [<ffffffff811c0050>] ? tty_poll+0x56/0x6d
 [<ffffffff810a0552>] ? do_select+0x330/0x507
 [<ffffffff810a0bf4>] ? __pollwait+0x0/0xcd
 [<ffffffff810a0cc1>] ? pollwake+0x0/0x47
 [<ffffffff810a0cc1>] ? pollwake+0x0/0x47
 [<ffffffff810a0cc1>] ? pollwake+0x0/0x47
 [<ffffffff810a0cc1>] ? pollwake+0x0/0x47
 [<ffffffff812fd009>] ? sk_reset_timer+0xf/0x1d
 [<ffffffff81334a00>] ? tcp_write_xmit+0x890/0x979
 [<ffffffff81331b61>] ? tcp_current_mss+0x3c/0x57
 [<ffffffff813a7188>] ? _spin_lock_bh+0x9/0x1f
 [<ffffffff812fcb98>] ? release_sock+0x13/0x95
 [<ffffffff81329a9f>] ? tcp_sendmsg+0x8c2/0x9b6
 [<ffffffff810a08d4>] ? core_sys_select+0x1ab/0x26f
 [<ffffffff810779e1>] ? __do_fault+0x3d4/0x40f
 [<ffffffff8104ce8e>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff810a0bcb>] ? sys_select+0x92/0xbb
 [<ffffffff8109406a>] ? sys_write+0x45/0x6e
 [<ffffffff8100b96b>] ? system_call_fastpath+0x16/0x1b
Code: 85 c0 74 10 f6 87 ec 00 00 00 01 75 07 8b 80 f0 00 00 00 c3 31 c0 c3 53 4\
8 89 fb 48 8b bf f8 00 00 00 48 85 ff 74 2a 48 8b 47 40 <48> 8b 00 48 8b 40 30 \
48 85 c0 74 1a ff d0 89 c2 48 8b 43 08 66
RIP  [<ffffffff811c7c9f>] pty_chars_in_buffer+0x14/0x40
 RSP <ffff8802330bd9a8>
CR2: 0000000000000000
---[ end trace 4eaa2a86a8e2da24 ]---



Regards,
Andreas



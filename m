Return-Path: <linux-kernel-owner+w=401wt.eu-S1946143AbXBPUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946143AbXBPUiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946144AbXBPUiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:38:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:9034 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946143AbXBPUiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:38:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=NhwK0CrjMxY7ncW+zCVAT8gPr4ti9DoGQBQTAncxtKk15sVitAKH70XqGtq8LpVX1wLi6O83vsHP3YimELpUnmI20XNnoMUBX01NQWYjuClVh2PkjZAyC3r6dH64vZUAWDNif5Yqlzf5XM34yf/ha/Kms4nA5udBfcdMRu4WA7I=
Message-ID: <45D61632.1020105@googlemail.com>
Date: Fri, 16 Feb 2007 21:38:10 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.20-git13 kernel BUG at /mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This looks like a tickless stuff

------------[ cut here ]------------
kernel BUG at /mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168!
invalid opcode: 0000 [#1]
PREEMPT SMP
Modules linked in: rtc unix
CPU:    0
EIP:    0060:[<c0139ea0>]    Not tainted VLI
EFLAGS: 00010002   (2.6.20 #53)
EIP is at tick_nohz_stop_sched_tick+0x5d/0x1d9
eax: 00000000   ebx: c6021100   ecx: 00000001   edx: c03e74e0
esi: c6022c40   edi: 00000000   ebp: c041dfac   esp: c041df78
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c041d000 task=c03e74e0 task.ti=c041d000)
Stack: 00000000 c03e7608 c6021b20 00000000 c041dfac 00000296 00000001 c602007b
       c01000d8 c0451304 c6021100 c0102b42 00000000 c041dfc0 c01023b4 c602ee80
       c0453ae4 c602b864 c041dfc8 c010141d c041dff8 c0421a52 c038d4da c04211ed
Call Trace:
 [<c01050f9>] show_trace_log_lvl+0x1a/0x2f
 [<c01051ab>] show_stack_log_lvl+0x9d/0xa5
 [<c01053a0>] show_registers+0x1ed/0x32c
 [<c01055f7>] die+0x118/0x22f
 [<c0105787>] do_trap+0x79/0x91
 [<c0106017>] do_invalid_op+0x97/0xa1
 [<c0311abc>] error_code+0x7c/0x84
 [<c01023b4>] cpu_idle+0x1d/0xfb
 [<c010141d>] rest_init+0x37/0x3a
 [<c0421a52>] start_kernel+0x459/0x461
 [<00000000>] 0x0
 =======================
Code: f0 ff ff 8b 40 08 a8 08 0f 85 74 01 00 00 e8 74 e7 0b 00 89 c7 bb 80 13 45 c0 e8 68 e7 0b 00 03 1c 85 00 a6 41 c0 83 3b 00 74 04 <0f> 0b eb fe 8d 45 ec e8 bf c0 ff ff 8b 4d ec 8b 5d f0 83 7e 3c
EIP: [<c0139ea0>] tick_nohz_stop_sched_tick+0x5d/0x1d9 SS:ESP 0068:c041df78
Kernel panic - not syncing: Attempted to kill the idle task!
BUG: at /mnt/md0/devel/linux-git/arch/i386/kernel/smp.c:547 smp_call_function()
 [<c01050f9>] show_trace_log_lvl+0x1a/0x2f
 [<c01057e0>] show_trace+0x12/0x14
 [<c0105892>] dump_stack+0x16/0x18
 [<c0112792>] smp_call_function+0x61/0x102
 [<c0112851>] smp_send_stop+0x1e/0x31
 [<c0121ae3>] panic+0x5e/0xfb
 [<c012463b>] do_exit+0x7a/0x702
 [<c01056e8>] die+0x209/0x22f
 [<c0105787>] do_trap+0x79/0x91
 [<c0106017>] do_invalid_op+0x97/0xa1
 [<c0311abc>] error_code+0x7c/0x84
 [<c01023b4>] cpu_idle+0x1d/0xfb
 [<c010141d>] rest_init+0x37/0x3a
 [<c0421a52>] start_kernel+0x459/0x461
 [<00000000>] 0x0
 =======================

0xc0139ea0 is in tick_nohz_stop_sched_tick (/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168).
163
164             if (need_resched())
165                     goto end;
166
167             cpu = smp_processor_id();
168             BUG_ON(local_softirq_pending());
169
170             now = ktime_get();
171             /*
172              * When called from irq_exit we need to account the idle sleep time


http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-git13/boot.log
http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-git13/git-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

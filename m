Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbZAUHP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbZAUHP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 02:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZAUHPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 02:15:20 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:42811 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZAUHPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 02:15:19 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended) 
Date: Wed, 21 Jan 2009 20:15:18 +1300
Message-ID: <87prihcepl.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got a couple of these on a PowerBook running 2.6.29-rc2 either during
suspend or resume -- it's hard to tell.  (The suspend message is
timestamped in syslog with the time I resumed, so I guess it was
buffered along with the subsequent "Badness" messages.)


Badness at kernel/time/timekeeping.c:98
NIP: c0053990 LR: c0053b10 CTR: c0348840
REGS: ee4fdba0 TRAP: 0700   Not tainted  (2.6.29-rc2-00001-g351549b)
MSR: 02023032 <FP,VEC,ME,CE,IR,DR>  CR: 24444284  XER: 20000000
TASK = ef2f7820[2700] 'pmud' THREAD: ee4fc000
GPR00: 00000001 ee4fdc50 ef2f7820 ee4fdc88 00000005 00000000 00000000 ef84a7fc
GPR08: 00000004 00000000 a9283f00 00000001 22444224 1001e68c 00000040 00000000
GPR16: 00000001 00000010 22444224 00000001 00000000 c067c05c 00000000 00000005
GPR24: c067c16d 00000006 c067c16c 00000005 ee4fdc88 ee4fdcb8 ef357400 00000000
NIP [c0053990] getnstimeofday+0x24/0x188
LR [c0053b10] do_gettimeofday+0x1c/0x58
Call Trace:
[ee4fdc80] [c0053b10] do_gettimeofday+0x1c/0x58
[ee4fdcb0] [c0348868] evdev_event+0x28/0x158
[ee4fdce0] [c0340ce4] input_pass_event+0xac/0xb0
[ee4fdd00] [c0343a44] input_event+0x80/0x98
[ee4fdd20] [c02f6d24] via_pmu_event+0x88/0x8c
[ee4fdd30] [c02f4f60] via_pmu_interrupt+0x6e0/0xb2c
[ee4fdd90] [c02f5664] pmu_wait_complete+0x50/0x84
[ee4fddb0] [c02f6764] powerbook_sleep+0x9f0/0xb24
[ee4fde40] [c00607f8] suspend_devices_and_enter+0x10c/0x180
[ee4fde60] [c0060a1c] enter_state+0x11c/0x160
[ee4fde80] [c02f4404] pmu_ioctl+0x15c/0x24c
[ee4fde90] [c00bab04] vfs_ioctl+0x8c/0x90
[ee4fdea0] [c00babb8] do_vfs_ioctl+0x8c/0x70c
[ee4fdf10] [c00bb2d4] sys_ioctl+0x9c/0xa4
[ee4fdf40] [c0012eb8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff59878
    LR = 0xff597dc
Instruction dump:
7f9c0040 40bdff90 4bffff48 9421ffd0 7c0802a6 3d20c05e 90010034 bf210014
7c7c1b78 816970a4 312bffff 7c095910 <0f000000> 3d40c05f 3d20c05f 3d60c05f
------------[ cut here ]------------
Badness at kernel/time/timekeeping.c:98
NIP: c0053990 LR: c0053b10 CTR: c0348840
REGS: ee4fdba0 TRAP: 0700   Tainted: G        W   (2.6.29-rc2-00001-g351549b)
MSR: 02023032 <FP,VEC,ME,CE,IR,DR>  CR: 44444284  XER: 20000000
TASK = ef2f7820[2700] 'pmud' THREAD: ee4fc000
GPR00: 00000001 ee4fdc50 ef2f7820 ee4fdc88 00000000 00000000 00000000 00000000
GPR08: c062f520 00000000 efae6240 00000001 44444284 1001e68c 00000040 00000000
GPR16: 00000001 00000010 22444224 00000001 00000000 c067c05c 00000000 00000005
GPR24: c067c16d 00000006 c067c16c 00000000 ee4fdc88 ee4fdcb8 ef357400 00000000
NIP [c0053990] getnstimeofday+0x24/0x188
LR [c0053b10] do_gettimeofday+0x1c/0x58
Call Trace:
[ee4fdc50] [ee4fdd00] 0xee4fdd00 (unreliable)
[ee4fdc80] [c0053b10] do_gettimeofday+0x1c/0x58
[ee4fdcb0] [c0348868] evdev_event+0x28/0x158
[ee4fdce0] [c0340ce4] input_pass_event+0xac/0xb0
[ee4fdd00] [c0343a44] input_event+0x80/0x98
[ee4fdd20] [c02f6cf0] via_pmu_event+0x54/0x8c
[ee4fdd30] [c02f4f60] via_pmu_interrupt+0x6e0/0xb2c
[ee4fdd90] [c02f5664] pmu_wait_complete+0x50/0x84
[ee4fddb0] [c02f6764] powerbook_sleep+0x9f0/0xb24
[ee4fde40] [c00607f8] suspend_devices_and_enter+0x10c/0x180
[ee4fde60] [c0060a1c] enter_state+0x11c/0x160
[ee4fde80] [c02f4404] pmu_ioctl+0x15c/0x24c
[ee4fde90] [c00bab04] vfs_ioctl+0x8c/0x90
[ee4fdea0] [c00babb8] do_vfs_ioctl+0x8c/0x70c
[ee4fdf10] [c00bb2d4] sys_ioctl+0x9c/0xa4
[ee4fdf40] [c0012eb8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff59878
    LR = 0xff597dc
Instruction dump:
7f9c0040 40bdff90 4bffff48 9421ffd0 7c0802a6 3d20c05e 90010034 bf210014
7c7c1b78 816970a4 312bffff 7c095910 <0f000000> 3d40c05f 3d20c05f 3d60c05f

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood

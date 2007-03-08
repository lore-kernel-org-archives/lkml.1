Return-Path: <linux-kernel-owner+w=401wt.eu-S1030757AbXCHWG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757AbXCHWG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030755AbXCHWG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:06:26 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:54180 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030757AbXCHWGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:06:25 -0500
Message-ID: <45F088DD.3030308@simon.arlott.org.uk>
Date: Thu, 08 Mar 2007 22:06:21 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: ebiederm@xmission.com
Subject: SysRq SAK panic on tty2
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have no idea when this broke, I was checking SAK worked at all since 
it's not on another box's serial console.

[    0.000000] Linux version 2.6.21-rc3-git (byte@redrum) (gcc version 3.4.6 (Gentoo 3.4.6-r1, ssp-3.4.5-1.0, pie-8.7.9)) #170 PREEMPT Thu Mar 8 21:19:28 GMT 2007

tty1 (console):
[  111.879184] SysRq : SAK
[  111.879417] SAK: killed process 6231 (agetty): process_session(p)==tty->session
[  111.879589] SAK: killed process 6231 (agetty): process_session(p)==tty->session

tty2:
[  122.983282] SysRq : SAK
[  122.983459] ------------[ cut here ]------------
[  122.983507] kernel BUG at kernel/workqueue.c:212!
[  122.983618] invalid opcode: 0000 [#1]
[  122.983661] PREEMPT
[  122.983736] Modules linked in: capability commoncap mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
[  122.984245] CPU:    0
[  122.984247] EIP:    0060:[<b0130bf1>]    Not tainted VLI
[  122.984249] EFLAGS: 00010017   (2.6.21-rc3-git #170)
[  122.984385] EIP is at queue_work+0x51/0x60
[  122.984494] eax: b0967c7c   ebx: 00000000   ecx: effec7a0   edx: b0967c78
[  122.984545] esi: 00000001   edi: 0000006b   ebp: b06bbdb8   esp: b06bbdb4
[  122.984595] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  122.984644] Process swapper (pid: 0, ti=b06ba000 task=b0660ca0 task.ti=b06ba000)
[  122.984751] Stack: b0967c78 b06bbdc0 b01313ff b06bbdd8 b03084c1 b06047fd 00000001 b0967c78
[  122.985232]        b0678210 b06bbe00 b0308778 b0603fdf b060481c 00000082 00000009 ebb83000
[  122.985776]        ebb83000 0000006b ebb83000 b06bbe10 b0308841 b0967a45 00000025 b06bbe48
[  122.986264] Call Trace:
[  122.986410]  [<b0104f4a>] show_trace_log_lvl+0x1a/0x30
[  122.986504]  [<b010500b>] show_stack_log_lvl+0x8b/0xb0
[  122.986650]  [<b0105253>] show_registers+0x1c3/0x320
[  122.986739]  [<b0105536>] die+0x106/0x230
[  122.986883]  [<b01056e2>] do_trap+0x82/0xc0
[  122.986970]  [<b01059f3>] do_invalid_op+0xa3/0xb0
[  122.987116]  [<b0510f04>] error_code+0x74/0x7c
[  122.987212]  [<b01313ff>] schedule_work+0xf/0x20
[  122.987357]  [<b03084c1>] sysrq_handle_SAK+0x31/0x40
[  122.987452]  [<b0308778>] __handle_sysrq+0x88/0x120
[  122.987599]  [<b0308841>] handle_sysrq+0x31/0x40
[  122.987687]  [<b0302e35>] kbd_keycode+0x335/0x3b0
[  122.987833]  [<b0302f8a>] kbd_event+0xda/0xf0
[  122.987920]  [<b03d4222>] input_event+0x152/0x430
[  122.988069]  [<b03d8f4e>] atkbd_interrupt+0x21e/0x520
[  122.988161]  [<b03d1e32>] serio_interrupt+0x42/0x80
[  122.988307]  [<b03d2845>] i8042_interrupt+0x105/0x250
[  122.988396]  [<b014b618>] handle_IRQ_event+0x28/0x60
[  122.988550]  [<b014c6f0>] handle_level_irq+0x70/0x100
[  122.988639]  [<b010692c>] do_IRQ+0x3c/0x80
[  122.988784]  [<b0104be2>] common_interrupt+0x2e/0x34
[  122.988873]  [<b01020e6>] cpu_idle+0x46/0x80
[  122.989017]  [<b0101037>] rest_init+0x37/0x40
[  122.989104]  [<b06bcbb5>] start_kernel+0x1c5/0x210
[  122.989257]  [<00000000>] 0x0
[  122.989342]  =======================
[  122.989391] Code: bb 01 00 00 00 e8 60 ff ff ff 89 e0 25 00 e0 ff ff ff 48 14 8b 40 08 a8 08 75 05 89 d8 5b c9 c3 e8 45 d6 3d 00 89 d8 5b c9 90 c3 <0f> 0b eb fe 8d 74 26 00 8d bc 27 00 00 00 00 55 8b 10 89 e5 83
[  122.992739] EIP: [<b0130bf1>] queue_work+0x51/0x60 SS:ESP 0068:b06bbdb4
[  122.992928] Kernel panic - not syncing: Fatal exception in interrupt
[  122.992985] Rebooting in 10 seconds...

-- 
Simon Arlott

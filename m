Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbXJRFAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbXJRFAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXJRFA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:00:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:52339 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752991AbXJRFAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:00:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18t96xjshwtt1+/NpviA1YnsJPKYTHNlVgXy4UJEP
	NWAi0biHPF4aBq
Subject: [serial?] 6.2.23.git.today poking SysRq-T triggers NMI watchdog
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 07:00:20 +0200
Message-Id: <1192683620.7390.8.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

When shutting down this kernel, my box is hanging when the init scripts
tries to set the hardware clock, so I fired up my serial console box,
and set nmi_watchdog=2, but nothing happened.  When I poked SysRq-T
however, I received the below.  I also notice that I can't login via
serial console with this kernel.

(the taint is due to previously posted oops loading microcode module)

[  257.624720] BUG: NMI Watchdog detected LOCKUP on CPU0, eip c04c00ed, registers:
[  257.632036] Modules linked in: radeon drm snd_pcm_oss w83781d hwmon_vid hwmon eeprom snd_mixer_oss snd_seq_midi snd_seq_midi_event microcode snd_seq edd button battery ac ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter ip6_tables x_tables nls_iso8859_1 nls_cp437 nls_utf8 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm prism54 snd_timer snd_mpu401 snd_mpu401_uart snd_rawmidi snd_seq_device intel_agp snd agpgart snd_page_alloc soundcore i2c_i801 fan thermal processor
[  257.683837] CPU:    0
[  257.683838] EIP:    0060:[<c04c00ed>]    Tainted: G      D VLI
[  257.683840] EFLAGS: 00000006   (2.6.23-smp-git #13)
[  257.696806] EIP is at _spin_lock_irqsave+0x51/0x66
[  257.701589] eax: 00000000   ebx: c061ffa0   ecx: 00000027   edx: 00000002
[  257.708369] esi: c068e000   edi: 00000074   ebp: c068ee60   esp: c068ee58
[  257.715151] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  257.720980] Process swapper (pid: 0, ti=c068e000 task=c06083c0 task.ti=c0645000)
[  257.728193] Stack: c2d0c000 00000001 c068ee88 c033e493 c2d0c11c c068ee78 c2d0c000 00000002 
[  257.736679]        c068ee80 c2d0c000 00000074 c2d0c000 c068ee98 c033e5ae 00000001 00000014 
[  257.745167]        c068eec0 c0338658 4716e406 0002d6d1 01010004 c39c0c00 00000014 c0338325 
[  257.753654] Call Trace:
[  257.756288]  [<c010514a>] show_trace_log_lvl+0x1a/0x30
[  257.761450]  [<c0105205>] show_stack_log_lvl+0xa5/0xca
[  257.766611]  [<c0105426>] show_registers+0x1fc/0x33d
[  257.771599]  [<c0105eb8>] die_nmi+0x86/0xd9
[  257.775799]  [<c011879c>] nmi_watchdog_tick+0x13b/0x140
[  257.781038]  [<c010623a>] do_nmi+0x80/0x253
[  257.785240]  [<c04c070b>] nmi_stack_correct+0x26/0x2b
[  257.790314]  [<c033e493>] __handle_sysrq+0x1a/0x115
[  257.795209]  [<c033e5ae>] handle_sysrq+0x20/0x24
[  257.799849]  [<c0338658>] kbd_event+0x333/0x5cb
[  257.804397]  [<c03beda1>] input_pass_event+0xb2/0xc3
[  257.809384]  [<c03bfa50>] input_handle_event+0x131/0x3b4
[  257.814712]  [<c03c084d>] input_event+0x54/0x67
[  257.819266]  [<c03c6005>] atkbd_interrupt+0x425/0x570
[  257.824332]  [<c03bba4a>] serio_interrupt+0x32/0x6c
[  257.829226]  [<c03bc642>] i8042_interrupt+0x10a/0x23f
[  257.834300]  [<c015988a>] handle_IRQ_event+0x2c/0x55
[  257.839280]  [<c015a9c1>] handle_edge_irq+0xbc/0x11d
[  257.844252]  [<c0106e6b>] do_IRQ+0x79/0xce
[  257.848366]  =======================
[  257.851941] Code: d0 5b 5e 5d c3 52 9d 83 6e 14 01 8b 46 08 a8 04 75 22 8b 43 04 85 c0 75 12 c7 43 04 01 00 00 00 eb 09 8b 4b 04 85 c9 74 c0 f3 90 <0f> b6 03 84 c0 7e f0 eb b5 e8 cb ed ff ff 90 8d 74 26 00 eb d2 



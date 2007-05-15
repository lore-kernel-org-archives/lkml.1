Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXEOLMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXEOLMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXEOLMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:12:46 -0400
Received: from klant.bhosted.nl ([217.148.95.132]:5587 "HELO
	server1.bhosted.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755261AbXEOLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:12:45 -0400
Message-ID: <3644.62.177.207.163.1179227559.squirrel@klant.bhosted.nl>
Date: Tue, 15 May 2007 13:12:39 +0200 (CEST)
Subject: [2.6.21.1] OOPS in timer stats code
From: "Folkert van Heusden" <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After an uptime of, say, 4 hours I got an oops on my P4 with HT and 2GB ram.
It has dynamic ticks enabled as well has timer stats. I cannot reboot the
machine to give more details right now (19:00 gmt+1 i can).

For now, this is the oops:

[13092.479019] BUG: unable to handle kernel paging request at virtual
address b9d0458f
[13092.479115]  printing eip:
[13092.479160] c10388a8
[13092.479202] *pde = 00000000
[13092.479246] Oops: 0000 [#1]
[13092.479290] SMP
[13092.479401] Modules linked in: wcfxo zaptel tuner tvaudio bttv
video_buf ir_common i2c_algo_bit btcx_risc tveeprom pl2303 pwc usbserial
nfs plusb w83627hf hwmon_vid usbnet snd_pcm_oss eeprom snd_mixer_oss
i2c_isa i2c_core snd_intel8x0 snd_ac97_codec snd_pcm sd_mod snd_timer
scsi_mod snd ide_cd soundcore snd_page_alloc cdrom ac97_bus parport_pc
parport microcode firmware_class netconsole nfsd exportfs lockd sunrpc
ipt_owner ip6table_filter ip6_tables ipv6 ipt_recent xt_limit xt_state
act_police sch_ingress cls_u32 sch_sfq sch_cbq ipt_REJECT ipt_MASQUERADE
ipt_TOS xt_tcpudp iptable_mangle iptable_filter rtl8150 e1000 3c59x mii
iptable_nat ip_tables nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink
x_tables capability commoncap ppp_deflate zlib_deflate zlib_inflate
ppp_async crc_ccitt ppp_generic slip slhc genrtc rd
[13092.483367] CPU:    1
[13092.483368] EIP:    0060:[<c10388a8>]    Not tainted VLI
[13092.483370] EFLAGS: 00010046   (2.6.21.1test #1)
[13092.483511] EIP is at match_entries+0xb/0x38
[13092.483558] eax: c25f9a80   ebx: 00000000   ecx: b9d0458b   edx: f039aec8
[13092.483610] esi: f039aec8   edi: c25f99a0   ebp: f039aea0   esp: f039ae9c
[13092.483660] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[13092.483712] Process einstein_S5R2_4 (pid: 12710, ti=f039a000
task=f7c32a70 task.ti=f039a000)
[13092.483760] Stack: b9d0458b f039aec0 c1038911 c12109e9 c12ffe10
c25f9ab0 00000096 c25f9b04
[13092.484181]        c25f99a0 f039af50 c10389ec c120e6eb c25f9a80
c10383ec c10385f0 00000000
[13092.484581]        00000000 c1495c78 00000000 00000000 c13f7230
00000001 f7c32fb8 c13f87c0
[13092.484988] Call Trace:
[13092.485105]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[13092.485220]  [<c1004e0a>] show_stack_log_lvl+0x8d/0xaa
[13092.485336]  [<c1005044>] show_registers+0x1cd/0x2cb
[13092.485457]  [<c10052a1>] die+0x11b/0x227
[13092.485578]  [<c1212aef>] do_page_fault+0x319/0x57a
[13092.485698]  [<c12110cc>] error_code+0x7c/0x84
[13092.485813]  [<c1038911>] tstat_lookup+0x3c/0xc9
[13092.485928]  [<c10389ec>] timer_stats_update_stats+0x4e/0x6f
[13092.486041]  [<c1033d5d>] hrtimer_interrupt+0x184/0x1e3
[13092.486156]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[13092.486272]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[13092.486390]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[13092.486510]  =======================
[13092.486575] Code: 3d ff 03 00 00 89 e5 77 13 89 c2 83 c0 01 c1 e2 07 a3
98 2c 37 c1 81 c2 00 2d 37 c1 89 d0 5d c3 55 89 c1 8b 42 04 89 e5 53 31 db
<39> 41 04 74 05 89 d8 5b 5d c3 8b 42 08 39 41 08 75 f3 8b 42 0c
[13092.489766] EIP: [<c10388a8>] match_entries+0xb/0x38 SS:ESP 0068:f039ae9c
[13092.489901] Kernel panic - not syncing: Fatal exception in interrupt
[13092.489951] BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
[13092.490003]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[13092.490091]  [<c1004d7b>] show_trace+0x12/0x14
[13092.490178]  [<c1004e75>] dump_stack+0x16/0x18
[13092.490267]  [<c100df63>] smp_call_function+0x10f/0x114
[13092.490367]  [<c100dfb9>] smp_send_stop+0x1e/0x31
[13092.490454]  [<c101ca83>] panic+0x50/0xf5
[13092.490548]  [<c100539e>] die+0x218/0x227
[13092.490640]  [<c1212aef>] do_page_fault+0x319/0x57a
[13092.490738]  [<c12110cc>] error_code+0x7c/0x84
[13092.490827]  [<c1038911>] tstat_lookup+0x3c/0xc9
[13092.490914]  [<c10389ec>] timer_stats_update_stats+0x4e/0x6f
[13092.491012]  [<c1033d5d>] hrtimer_interrupt+0x184/0x1e3
[13092.491113]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[13092.491201]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[13092.491289]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[13092.491381]  =======================


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYDWN1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYDWN1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYDWN1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:27:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:57297 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752952AbYDWN1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:27:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18/XuFe++M/sjHUYhLP3vk/zyB05M8JBUhrV3JdCm
	UHf8TVF3mCpIOd
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1208949715.7115.334.camel@twins>
References: <20080419181304.GB21353@elte.hu>
	 <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu>
	 <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu>
	 <1208854300.4695.7.camel@marge.simson.net>  <20080422085905.GA9939@elte.hu>
	 <1208867154.4873.4.camel@marge.simson.net>
	 <1208938303.4905.23.camel@marge.simson.net>
	 <1208946604.4803.9.camel@marge.simson.net>
	 <1208949715.7115.334.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Date: Wed, 23 Apr 2008 15:27:06 +0200
Message-Id: <1208957226.4223.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-23 at 13:21 +0200, Peter Zijlstra wrote:

> this should fix it:

Did.  But...

Continuing testing, x86/latest doesn't seem to hard lock (though i'm
going to run a while longer to be sure).  However, it does do something
else. watch-rq-clock.sh is triggering an occasional oops.  After the
oops, instead of heading off to bit heaven, grep hangs around eating
100% cpu, _possibly_ until it's parent is killed.  I say possibly,
because that's what it looked like the first time.  Also, amarok
suddenly ceased playing and exited without a peep... weird.  I restarted
amarok, kept testing and repeated the oops, but just as luck would have
it, my keyboard went away again, so I had to reboot before I was able to
see if killing watch-rq-clock.sh would kill the runaway grep again, or
if amarok was going to go awol again.

[  399.477589] BUG: unable to handle kernel NULL pointer dereference at 0000000000000418
[  399.481049] IP: [<ffffffff802296d2>] calc_delta_weight+0x17/0x37
[  399.481049] PGD 7b0ba067 PUD 7b1a2067 PMD 0 
[  399.481049] Oops: 0000 [1] SMP 
[  399.481049] CPU 2 
[  399.481049] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter ip6_tables x_tables cpufreq_conservative cpufreq_userspace ipv6 cpufreq_powersave acpi_cpufreq microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 saa7134 snd_hda_intel compat_ioctl32 videodev v4l1_compat v4l2_common snd_pcm firewire_ohci videobuf_dma_sg firewire_core snd_timer videobuf_core ir_kbd_i2c usbhid snd_page_alloc ir_common crc_itu_t snd_hwdep usb_storage snd tveeprom e1000e ohci1394 hid iTCO_wdt rtc_cmos i2c_i801 ieee1394 iTCO_vendor_support intel_agp rtc_core sr_mod i2c_core rtc_lib button serio_raw ff_memless sg cdrom soundcore ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[  399.481049] Pid: 20646, comm: grep Not tainted 2.6.26-devel-smp #2
[  399.481049] RIP: 0010:[<ffffffff802296d2>]  [<ffffffff802296d2>] calc_delta_weight+0x17/0x37
[  399.481049] RSP: 0018:ffff8100994bdd88  EFLAGS: 00010286
[  399.481049] RAX: 0000000000000400 RBX: ffff81000102be30 RCX: 0000000000000000
[  399.481049] RDX: ffffffff805b1dc0 RSI: 0000000000000001 RDI: 0000000000000400
[  399.481049] RBP: ffff8100994bdd88 R08: ffff81007b1606af R09: ffff81008c47b2a0
[  399.481049] R10: ffffffffffffffff R11: 0000000000000000 R12: ffff810001022e58
[  399.481049] R13: ffff81008c47b2a0 R14: ffff810001022dc0 R15: 0000000000000000
[  399.481049] FS:  00007fe5fcefa6f0(0000) GS:ffff8100bf80e500(0000) knlGS:0000000000000000
[  399.481049] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  399.481049] CR2: 0000000000000418 CR3: 000000007b015000 CR4: 00000000000006e0
[  399.481049] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  399.481049] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  399.481049] Process grep (pid: 20646, threadinfo ffff8100994bc000, task ffff81008c5bc000)
[  399.481049] Stack:  ffff8100994bde58 ffffffff8022d46b ffffffff805348e8 00000010000240d0
[  399.481049]  ffffe20001aecd00 ffffffff805b1dc0 ffffffff805b1dc0 ffff8100acc36441
[  399.481049]  0000000000008001 0000000000000001 00000000000040d0 00000000000040d0
[  399.481049] Call Trace:
[  399.481049]  [<ffffffff8022d46b>] sched_debug_show+0x9b3/0xd2b
[  399.481049]  [<ffffffff80273825>] ? alloc_pages_node+0x31/0x36
[  399.481049]  [<ffffffff8027388b>] ? __get_free_pages+0xf/0x4c
[  399.481049]  [<ffffffff802a99e1>] seq_read+0x10b/0x29a
[  399.481049]  [<ffffffff802cac38>] proc_reg_read+0x7b/0x95
[  399.481049]  [<ffffffff80290da6>] vfs_read+0xa8/0x102
[  399.481049]  [<ffffffff80291056>] sys_read+0x47/0x6d
[  399.481049]  [<ffffffff8020c2db>] system_call_after_swapgs+0x7b/0x80
[  399.481049] 
[  399.481049] 
[  399.481049] Code: 89 da e8 a7 fe ff ff 48 01 43 50 4c 89 63 40 5b 41 5c c9 c3 55 48 85 f6 48 89 e5 74 29 48 8b 46 d0 48 c7 c2 c0 1d 5b 80 48 8b 36 <8b> 40 18 48 8b 04 c5 a0 41 56 80 48 03 50 08 48 83 c2 60 e8 6b 
[  399.481049] RIP  [<ffffffff802296d2>] calc_delta_weight+0x17/0x37
[  399.481049]  RSP <ffff8100994bdd88>
[  399.481049] CR2: 0000000000000418
[  399.481052] ---[ end trace 36afd5990b2873de ]---



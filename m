Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZH1Kuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZH1Kuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 06:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZH1Kuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 06:50:50 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:1798 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZH1Kus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 06:50:48 -0400
Date: Fri, 28 Aug 2009 12:50:46 +0200 (CEST)
From: =?ISO-8859-2?Q?Pawe=B3_Go=B3aszewski?= <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: PROBLEM: oops
In-Reply-To: <alpine.LNX.2.00.0908271548160.16876@fgnss.gnfx.tqn.cy>
Message-ID: <alpine.LNX.2.00.0908281247160.16876@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>  <1251209206.7538.1159.camel@twins>  <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>  <1251209734.7538.1160.camel@twins>  <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy> 
 <1251211483.7538.1162.camel@twins>  <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>  <1251212859.7538.1166.camel@twins>  <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>  <1251265742.7538.1192.camel@twins>  <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy>
  <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy> <1251364230.18584.52.camel@twins> <alpine.LNX.2.00.0908271548160.16876@fgnss.gnfx.tqn.cy>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-1251220425-1251456647=:16876"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-1251220425-1251456647=:16876
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Aug 2009, Pawel Golaszewski wrote:
> Checked 2.6.27.25 - crashed. Problem is somewhere between 2.6.27.13 and 
> 2.6.27.25.

2.6.27.17 crashed too, but a bit differently:
[...]
[  773.097432] BUG: soft lockup - CPU#2 stuck for 61s! [md2_raid10:1683]
[  773.097432] Kernel panic - not syncing: softlockup: hung tasks
[  773.097432] ------------[ cut here ]------------
[  773.097432] WARNING: at kernel/mutex.c:351 mutex_trylock+0xa5/0xd0()
[  773.097432] Modules linked in: softdog netconsole configfs sch_sfq xfs raid10 ppdev uhci_hcd eepro100 ehci_hcd parport_pc parport i2c_piix4 piix e100 thermal usbcore ide_core container e1000 i2c_core psmouse mii sg pcspkr button processor serio_raw evdev ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
[  773.099637] Pid: 1683, comm: md2_raid10 Not tainted 2.6.27.17-1 #1
[  773.099637]  [<c0826dff>] warn_on_slowpath+0x5f/0xa0
[  773.099637]  [<f8a231c1>] __this_module+0x21fe1/0x227f0 [netconsole]
[  773.099637]  [<f8a23130>] __this_module+0x21f50/0x227f0 [netconsole]
[  773.099637]  [<c0827126>] __call_console_drivers+0x56/0x70
[  773.099637]  [<c084045b>] up+0xb/0x40
[  773.099637]  [<c0827673>] release_console_sem+0x1b3/0x1f0
[  773.099637]  [<c0a9bb95>] mutex_trylock+0xa5/0xd0
[  773.099637]  [<c086032f>] crash_kexec+0x1f/0xd0
[  773.099637]  [<c0831347>] lock_timer_base+0x27/0x50
[  773.099637]  [<c0967e8e>] vga_set_palette+0xbe/0x110
[  773.099637]  [<c0967e8e>] vga_set_palette+0xbe/0x110
[  773.099637]  [<c0968333>] vgacon_set_cursor_size+0x93/0x130
[  773.099637]  [<c0a9a957>] panic+0x4b/0xe3
[  773.099637]  [<c0871031>] softlockup_tick+0x191/0x1a0
[  773.099637]  [<c08310ec>] update_process_times+0x2c/0x60
[  773.099637]  [<c08505eb>] tick_sched_timer+0x6b/0xe0
[  773.099637]  [<c083f037>] __run_hrtimer+0x97/0xb0
[  773.099637]  [<c0850580>] tick_sched_timer+0x0/0xe0
[  773.099637]  [<c083fc7f>] hrtimer_interrupt+0x17f/0x1f0
[  773.099637]  [<c08134d8>] smp_apic_timer_interrupt+0x58/0x90
[  773.099637]  [<c0804e48>] apic_timer_interrupt+0x28/0x30
[  773.099637]  [<f8a29fed>] cleanup_module+0x2bdd/0x478b [raid10]
[  773.099637]  [<c0a9b85d>] schedule_timeout+0xbd/0xf0
[  773.099637]  [<c0804d53>] common_interrupt+0x23/0x30
[  773.099637]  [<c083bd11>] finish_wait+0x31/0x80
[  773.099637]  [<f882d479>] md_register_thread+0xc9/0x180 [md_mod]
[  773.099637]  [<c083bba0>] autoremove_wake_function+0x0/0x40
[  773.099637]  [<f882d450>] md_register_thread+0xa0/0x180 [md_mod]
[  773.099637]  [<c083b8f9>] kthread+0x39/0x70
[  773.099637]  [<c083b8c0>] kthread+0x0/0x70
[  773.099637]  [<c0805007>] kernel_thread_helper+0x7/0x10
[  773.099637]  =======================
[  773.099637] ---[ end trace 5cfcde0c2c70ce60 ]---
[  773.099637] ------------[ cut here ]------------
[  773.099637] WARNING: at kernel/smp.c:332 smp_call_function_mask+0x16d/0x1c0()
[  773.099637] Modules linked in: softdog netconsole configfs sch_sfq xfs raid10 ppdev uhci_hcd eepro100 ehci_hcd parport_pc parport i2c_piix4 piix e100 thermal usbcore ide_core container e1000 i2c_core psmouse mii sg pcspkr button processor serio_raw evdev ext3 jbd mbcache
[...]

Problem is somewhere 2.6.27.13-2.6.27.17. 

-- 
pozdr.  Paweł Gołaszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-1251220425-1251456647=:16876--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbZH0NyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbZH0NyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZH0NyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:54:08 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:3478 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbZH0NyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:54:06 -0400
Date: Thu, 27 Aug 2009 15:54:03 +0200 (CEST)
From: Pawel Golaszewski <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: PROBLEM: oops
In-Reply-To: <1251364230.18584.52.camel@twins>
Message-ID: <alpine.LNX.2.00.0908271548160.16876@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>  <1251209206.7538.1159.camel@twins>  <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>  <1251209734.7538.1160.camel@twins>  <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy> 
 <1251211483.7538.1162.camel@twins>  <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>  <1251212859.7538.1166.camel@twins>  <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>  <1251265742.7538.1192.camel@twins>  <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy>
  <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy> <1251364230.18584.52.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-935838548-1251381243=:16876"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-935838548-1251381243=:16876
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Aug 2009, Peter Zijlstra wrote:
> > > > > > > > could you try to reproduce without that?
> > > > > > > > 
> > > > > > > > CONFIG_GROUP_SCHED=n
> > > > > > > I'll try. 
> > > > > It seems that problem still exists - system has crashed too. From 
> > > > > netconsole: Any ideas? Last kernel I was using is 2.6.27.13 - works 
> > > > > fine. None between 13 and 31 tested...
> > > > # git log --format=oneline v2.6.27.13..v2.6.27.31 kernel/sched*
> > > > 2b46f3769896dc04e1e49144d282e4655677105a wait: prevent exclusive waiter starvation
> > > > 
> > > > Nothing changed anywhere near the code that is falling apart..
> > > I have 2 machines with the same hardware and similar software. On 
> > > one .13 is stable - I will test it on the second one. Should be too.
> > I've checked it - 2.6.27.13 is stable for me.
> > 
> > Conclusion: there is something wrong between 2.6.27.13 and 2.6.27.31 
> > What can I do about that? I'm not kernel-hacker...
> Unless any of the memory debugging options yield a clue the best you can 
> do is a bisection I'm afraid.
> 
> # git log --format=oneline v2.6.27.13..v2.6.27.31 | wc -l
> 630

Checked 2.6.27.25 - crashed. Problem is somewhere between 2.6.27.13 and 
2.6.27.25. I will check one or two more kernels - sorry, I can't play more 
on that machine...
>From console - will it help?:

[ 4243.524886] BUG: unable to handle kernel <1>BUG: unable to handle kernel paging request at ffffffd8
[ 4243.524935] IP: [<c081cc50>] hrtick_start_fair+0x0/0x30
[ 4243.524991] *pde = 00008067 *pte = 00000000 
[ 4243.525006] Oops: 0000 [#1] SMP 
[ 4243.525017] Modules linked in: softdog netconsole configfs sch_sfq xfs raid10 ppdev uhci_hcd eepro100 parport_pc ehci_hcd parport piix psmouse e100 i2c_piix4 serio_raw evdev thermal usbcore e1000 mii ide_core container i2c_core sg pcspkr processor button ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
[ 4243.525087] 
[ 4243.525097] Pid: 1783, comm: xfsbufd Not tainted (2.6.27.25-1 #1)
[ 4243.525105] EIP: 0060:[<c081cc50>] EFLAGS: 00010046 CPU: 0
[ 4243.525118] EIP is at hrtick_start_fair+0x0/0x30
[ 4243.525125] EAX: c1d8be00 EBX: c1d8be00 ECX: 00000001 EDX: ffffffd4
[ 4243.525133] ESI: 00000000 EDI: ffffffd4 EBP: c1d8be00 ESP: f72afec4
[ 4243.525140]  DS: 0068 ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 4243.525148] Process xfsbufd (pid: 1783, ti=f72ae000 task=f78af980 task.ti=f72ae000)
[ 4243.525157] Stack: c081cd5b 00000000 c1d8be00 c1d8be00 c0ac9f00 f78af980 00000000 c1d8be00 
[ 4243.525171]        c0a9b593 00000000 00000082 f88b5044 00000004 f72aff14 f78af980 c1d8be00 
[ 4243.525184]        c1d8c288 000003db 00000000 00000000 f72514f0 00200286 00003e00 f78afb08 
[ 4243.525198] Call Trace:
[ 4243.525205]  [<c081cd5b>] pick_next_task_fair+0xdb/0x100
[ 4243.525220]  [<c0a9b593>] schedule+0x5b3/0xc00
[ 4243.525255]  [<f88b5044>] ahc_print_path+0xba4/0x1090 [aic7xxx]
[ 4243.525313]  [<c0830837>] lock_timer_base+0x27/0x50
[ 4243.525332]  [<c08309c9>] __mod_timer+0xa9/0xf0
[ 4243.525341]  [<c08308a1>] try_to_del_timer_sync+0x41/0x50
[ 4243.525351]  [<c0a9bf2d>] schedule_timeout+0x8d/0xf0
[ 4243.525363]  [<c0830440>] process_timeout+0x0/0x10
[ 4243.525372]  [<c0a9bf28>] schedule_timeout+0x88/0xf0
[ 4243.525382]  [<f8b0f3df>] xfs_free_buftarg+0x9f/0x160 [xfs]
[ 4243.525523]  [<f8b0f380>] xfs_free_buftarg+0x40/0x160 [xfs]
[ 4243.525554]  [<c083ade9>] kthread+0x39/0x70
[ 4243.525575]  [<c083adb0>] kthread+0x0/0x70
[ 4243.525583]  [<c0805007>] kernel_thread_helper+0x7/0x10
[ 4243.525603]  =======================
[ 4243.525607] Code: 5e 5f 5d c3 8d b4 26 00 00 00 00 8d 73 3c 89 f0 e8 56 ef ff ff 8b 7f 48 85 ff 74 dc 89 ea 89 f0 e8 a6 fe ff ff eb d1 8d 74 26 00 <8b> 52 04 b9 00 3e 00 00 8b 52 10 8b 14 95 c0 f6 c0 c0 8d 94 11 
[ 4243.525670] EIP: [<c081cc50>] hrtick_start_fair+0x0/0x30 SS:ESP 0068:f72afec4
[ 4243.526080] Kernel panic - not syncing: Fatal exception
[ 4243.526120] ------------[ cut here ]------------
[ 4243.526127] WARNING: at kernel/smp.c:332 smp_call_function_mask+0x16d/0x1c0()
[ 4243.526133] Modules linked in: softdog netconsole configfs sch_sfq xfs raid10 ppdev uhci_hcd eepro100 parport_pc ehci_hcd parport piix psmouse e100 i2c_piix4 serio_raw evdev thermal usbcore e1000 mii ide_core container i2c_core sg pcspkr processor button ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
[ 4243.526192] Pid: 1783, comm: xfsbufd Tainted: G      D   2.6.27.25-1 #1
[ 4243.526199]  [<c082629f>] warn_on_slowpath+0x5f/0xa0
[ 4243.526223]  [<c0a9ae54>] printk+0x17/0x1b
[ 4243.526233]  [<c08408df>] sched_clock_cpu+0x11f/0x180
[ 4243.526252]  [<c083f925>] down_trylock+0x25/0x40
[ 4243.526261]  [<c083f925>] down_trylock+0x25/0x40
[ 4243.526269]  [<c08268fa>] try_acquire_console_sem+0xa/0x30
[ 4243.526281]  [<c085434d>] smp_call_function_mask+0x16d/0x1c0
[ 4243.526291]  [<c085f85c>] crash_kexec+0x6c/0xd0
[ 4243.526316]  [<c0850020>] tick_nohz_stop_sched_tick+0x300/0x390
[ 4243.526326]  [<c0830837>] lock_timer_base+0x27/0x50
[ 4243.526335]  [<c0967eee>] vga_set_palette+0xbe/0x110
[ 4243.526362]  [<c0967eee>] vga_set_palette+0xbe/0x110
[ 4243.526372]  [<c08543b4>] smp_call_function+0x14/0x20
[ 4243.526381]  [<c081249e>] native_smp_send_stop+0x1e/0x30
[ 4243.526406]  [<c0a9adab>] panic+0x51/0xe3
[ 4243.526415]  [<c0a9df34>] oops_end+0xa4/0xb0
[ 4243.526429]  [<c0a9fc08>] do_page_fault+0x368/0x730
[ 4243.526443]  [<c089bbc4>] slab_pad_check+0x44/0x140
[ 4243.526474]  [<c089c0df>] check_object+0xdf/0x210
[ 4243.526485]  [<c087a220>] mempool_alloc+0x40/0x100
[ 4243.526508]  [<c089dbfa>] __slab_alloc+0x4aa/0x590
[ 4243.526520]  [<c089c0df>] check_object+0xdf/0x210
[ 4243.526529]  [<c087a220>] mempool_alloc+0x40/0x100
[ 4243.526538]  [<c087a220>] mempool_alloc+0x40/0x100
[ 4243.526547]  [<c087a220>] mempool_alloc+0x40/0x100
[ 4243.526557]  [<f8858020>] scsi_free_command+0x80/0xb0 [scsi_mod]
[ 4243.526615]  [<c0951cbf>] __sg_alloc_table+0x5f/0xf0
[ 4243.526632]  [<c0a9f8a0>] do_page_fault+0x0/0x730
[ 4243.526641]  [<c0a9dbc5>] error_code+0x75/0x80
[ 4243.526650]  [<c081cc50>] hrtick_start_fair+0x0/0x30
[ 4243.526660]  [<c081cd5b>] pick_next_task_fair+0xdb/0x100
[ 4243.526670]  [<c0a9b593>] schedule+0x5b3/0xc00
[ 4243.526681]  [<f88b5044>] ahc_print_path+0xba4/0x1090 [aic7xxx]
[ 4243.526701]  [<c0830837>] lock_timer_base+0x27/0x50
[ 4243.526710]  [<c08309c9>] __mod_timer+0xa9/0xf0
[ 4243.526718]  [<c08308a1>] try_to_del_timer_sync+0x41/0x50
[ 4243.526727]  [<c0a9bf2d>] schedule_timeout+0x8d/0xf0
[ 4243.526737]  [<c0830440>] process_timeout+0x0/0x10
[ 4243.526745]  [<c0a9bf28>] schedule_timeout+0x88/0xf0
[ 4243.526755]  [<f8b0f3df>] xfs_free_buftarg+0x9f/0x160 [xfs]
[ 4243.526786]  [<f8b0f380>] xfs_free_buftarg+0x40/0x160 [xfs]
[ 4243.526816]  [<c083ade9>] kthread+0x39/0x70
[ 4243.526825]  [<c083adb0>] kthread+0x0/0x70
[ 4243.526833]  [<c0805007>] kernel_thread_helper+0x7/0x10
[ 4243.526842]  =======================
[ 4243.526847] ---[ end trace bce437568718debf ]---
[ 4243.526871] Rebooting in 10 seconds..NULL pointer dereference at 00000000
[ 4243.527499] IP: [<c094c633>] rb_insert_color+0x53/0x100
[ 4243.527499] *pde = 00000000 
[ 4243.527499] Oops: 0002 [#2] SMP 
[ 4243.527499] Modules linked in: softdog netconsole configfs sch_sfq xfs raid10 ppdev uhci_hcd eepro100 parport_pc ehci_hcd parport piix psmouse e100 i2c_piix4 serio_raw evdev thermal usbcore e1000 mii ide_core container i2c_core sg pcspkr processor button ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
[ 4243.527499] 
[ 4243.527499] Pid: 207, comm: kswapd0 Tainted: G      D W (2.6.27.25-1 #1)
[ 4243.527499] EIP: 0060:[<c094c633>] EFLAGS: 00010002 CPU: 3
[ 4243.527499] EIP is at rb_insert_color+0x53/0x100
[ 4243.527499] EAX: 00000000 EBX: c1d8be00 ECX: f78af9b4 EDX: c1d8be60
[ 4243.527499] ESI: f71c9b00 EDI: f78af9b4 EBP: f71c9b34 ESP: f7a47e6c
[ 4243.527499]  DS: 0068 ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 4243.527499] Process kswapd0 (pid: 207, ti=f7a46000 task=f7922400 task.ti=f7a46000)
[ 4243.527499] Stack: c1d8be3c c1d8be60 c1d8be00 f71c9b00 c1d8be3c f71c9b2c c081da54 00000000 
[ 4243.527499]        c1da0e00 c0ac9f00 f71c9b00 05ca51ee 000003dc c081ba46 c1da0e00 f71cb214 
[ 4243.527499]        f71c9b00 0000012c c0a9b560 f7a47f14 00000086 00000079 c1d8be00 00000001 
[ 4243.527499] Call Trace:
[ 4243.527499]  [<c081da54>] enqueue_task_fair+0x94/0xe0
[ 4243.527499]  [<c081ba46>] enqueue_task+0x26/0x80
[ 4243.527499]  [<c0a9b560>] schedule+0x580/0xc00
[ 4243.527499]  [<c0882c2f>] kswapd+0x4df/0x520
[ 4243.527499]  [<c0881270>] isolate_pages_global+0x0/0x60
[ 4243.527499]  [<c083b090>] autoremove_wake_function+0x0/0x40
[ 4243.527499]  [<c0882750>] kswapd+0x0/0x520
[ 4243.527499]  [<c083ade9>] kthread+0x39/0x70
[ 4243.527499]  [<c083adb0>] kthread+0x0/0x70
[ 4243.527499]  [<c0805007>] kernel_thread_helper+0x7/0x10
[ 4243.527499]  =======================
[ 4243.527499] Code: 74 5e 85 db 74 32 8b 13 f6 c2 01 75 2b 83 ca 01 89 13 89 f3 83 0f 01 89 dd 8b 3e 83 e7 fe 89 3e 83 e7 fc 75 cb 8b 54 24 04 8b 02 <83> 08 01 83 c4 08 5b 5e 5f 5d c3


-- 
pozdr.  Paweł Gołaszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-935838548-1251381243=:16876--

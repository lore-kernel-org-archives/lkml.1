Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZHYVXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZHYVXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZHYVXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:23:18 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:4583 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZHYVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:23:17 -0400
Date: Tue, 25 Aug 2009 23:23:13 +0200 (CEST)
From: Pawel Golaszewski <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: oops
In-Reply-To: <1251212859.7538.1166.camel@twins>
Message-ID: <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>  <1251209206.7538.1159.camel@twins>  <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>  <1251209734.7538.1160.camel@twins>  <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy> 
 <1251211483.7538.1162.camel@twins>  <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy> <1251212859.7538.1166.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-2059302876-1251235393=:17744"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-2059302876-1251235393=:17744
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Tue, 25 Aug 2009, Peter Zijlstra wrote:
> > > could you try to reproduce without that?
> > > 
> > > CONFIG_GROUP_SCHED=n
> > I'll try. 

It seems that problem still exists - system has crashed too. From 
netconsole:
[20621.263297] BUG: unable to handle kernel paging request at ffffffd8
[20621.263396] IP: [<c081cc50>] hrtick_start_fair+0x0/0x30
[20621.263480] Oops: 0000 [#1] SMP 
[20621.263525] Modules linked in: configs softdog netconsole configfs sch_sfq xfs raid10 eepro100 uhci_hcd ppdev parport_pc parport floppy i2c_piix4 ehci_hcd piix e100 psmouse thermal button container e1000 mii i2c_core ide_core pcspkr serio_raw evdev processor sg usbcore ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
[20621.264015] 
[20621.264042] Pid: 25390, comm: nnrpd Not tainted (2.6.27.31-1 #1)
[20621.264077] EIP: 0060:[<c081cc50>] EFLAGS: 00210046 CPU: 0
[20621.264116] EIP is at hrtick_start_fair+0x0/0x30
[20621.264148] EAX: c1d8a1e0 EBX: c1d8a1e0 ECX: 00000003 EDX: ffffffd4
[20621.264183] ESI: 00000000 EDI: ffffffd4 EBP: c1d8a1e0 ESP: f33d3b38
[20621.264218]  DS: 0068 ES: 007b FS: 00d8 GS: 0033 SS: 0068
[20621.264253] Process nnrpd (pid: 25390, ti=f33d2000 task=ee635640 task.ti=f33d2000)
[20621.264290] Stack: c081cd5b 00000000 00000000 c1d8a660 c0acaf00 00000100 00000000 c1d8a1e0 
[20621.264403]        c0a9beb3 f33d3bb8 00000000 00000000 00000000 00000000 ee635640 c1d8a1e0 
[20621.264515]        c1d8a668 00000000 00000000 00000000 00000000 00000000 000021e0 ee6357c8 
[20621.264619] Call Trace:
[20621.264619]  [<c081cd5b>] pick_next_task_fair+0xdb/0x100
[20621.264619]  [<c0a9beb3>] schedule+0x5b3/0xc00
[20621.264619]  [<c0830827>] lock_timer_base+0x27/0x50
[20621.264619]  [<c08309b9>] __mod_timer+0xa9/0xf0
[20621.264619]  [<c09480cd>] gr_log_resource+0x2d/0xf0
[20621.264619]  [<c0a9c84d>] schedule_timeout+0x8d/0xf0
[20621.264619]  [<c0830430>] process_timeout+0x0/0x10
[20621.264619]  [<c0a9c848>] schedule_timeout+0x88/0xf0
[20621.264619]  [<c08b231d>] do_sys_poll+0x30d/0x390
[20621.264619]  [<f89dedd0>] init_module+0xcdd0/0xcfe0 [sch_sfq]
[20621.264619]  [<c08b3300>] __pollwait+0x0/0x100
[20621.264619]  [<c08209c0>] default_wake_function+0x0/0x10
[20621.264619]  [<c0a110f2>] ip_finish_output+0x122/0x2a0
[20621.264619]  [<c0a0eafa>] ip_cork_release+0x2a/0x40
[20621.264619]  [<c0a105f1>] ip_push_pending_frames+0x2a1/0x360
[20621.264619]  [<c0a2e6bf>] udp_push_pending_frames+0x14f/0x3a0
[20621.264619]  [<c0a9e2d8>] _spin_lock_bh+0x8/0x20
[20621.264619]  [<c09de302>] release_sock+0x12/0xa0
[20621.264619]  [<c0a2fe9f>] udp_sendmsg+0x1af/0x680
[20621.264619]  [<c08a094f>] mem_cgroup_charge_common+0x1f/0x2c0
[20621.264619]  [<c087723d>] find_get_page+0x1d/0x90
[20621.264619]  [<c0a36809>] inet_sendmsg+0x29/0x60
[20621.264619]  [<c09db8d1>] sock_sendmsg+0x111/0x1b0
[20621.264619]  [<c083b080>] autoremove_wake_function+0x0/0x40
[20621.264619]  [<c0887d72>] handle_mm_fault+0x1c2/0x9b0
[20621.264619]  [<c0a08f47>] ip_route_output_flow+0x67/0x2b0
[20621.264619]  [<c08476d8>] ip_v4_find_src+0x88/0x330
[20621.264619]  [<c0a2becb>] ip4_datagram_connect+0x22b/0x2b0
[20621.264619]  [<c0aa060d>] do_page_fault+0x44d/0x740
[20621.264619]  [<c0a36866>] inet_dgram_connect+0x26/0x80
[20621.264619]  [<c09dc85e>] sys_connect+0xee/0x100
[20621.264619]  [<c08d36ef>] inotify_d_instantiate+0xf/0x40
[20621.264619]  [<c08b7fa6>] d_instantiate+0x46/0x70
[20621.264619]  [<c09dc767>] sys_send+0x37/0x40
[20621.264619]  [<c09dd427>] sys_socketcall+0x1c7/0x2b0
[20621.264619]  [<c08b2659>] sys_poll+0x39/0x90
[20621.264619]  [<c0803d54>] sysenter_do_call+0x12/0x21
[20621.264619]  =======================
[20621.264619] Code: 5e 5f 5d c3 8d b4 26 00 00 00 00 8d 73 3c 89 f0 e8 56 ef ff ff 8b 7f 48 85 ff 74 dc 89 ea 89 f0 e8 a6 fe ff ff eb d1 8d 74 26 00 <8b> 52 04 b9 e0 21 00 00 8b 52 10 8b 14 95 c0 f6 c0 c0 8d

Any ideas?

Last kernel I was using is 2.6.27.13 - works fine. None between 13 and 31 
tested...

-- 
pozdr.  Pawe³ Go³aszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-2059302876-1251235393=:17744--

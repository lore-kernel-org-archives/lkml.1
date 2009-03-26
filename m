Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZCZN7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZCZN7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbZCZN7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:59:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbZCZN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:59:31 -0400
Date: Thu, 26 Mar 2009 09:59:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Maneesh Soni <maneesh@in.ibm.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [-tip] ftrace: oops at probe_wakeup_sched_switch+0xd1/0x1ae
In-Reply-To: <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903260956100.17665@gandalf.stny.rr.com>
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 26 Mar 2009, Steven Rostedt wrote:

> 
> On Thu, 26 Mar 2009, Frederic Weisbecker wrote:
> 
> > On Thu, Mar 26, 2009 at 05:58:07PM +0530, Maneesh Soni wrote:
> > > 
> > > I hit the below oops while playing with "wakeup" tracer. Just enabled
> > > tracing and ran "while true; do cat trace; done" on a 8-way systems with
> > > -tip at commit 9e25bacc221318a29d37425e054c01047edad7f5.
> > > 
> > > 
> > > Attached the .config.
> > > 
> > > Thanks
> > > Maneesh
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > > IP: [<ffffffff802d2258>] probe_wakeup_sched_switch+0xd1/0x1ae
> > > PGD 219147067 PUD 1e449e067 PMD 0 
> > > Oops: 0000 [#1] SMP 
> > > last sysfs file: /sys/devices/pci0000:0c/0000:0c:00.0/irq
> > > CPU 5 
> > > Modules linked in: autofs4 hidp rfcomm l2cap bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc battery ac parport_pc lp parport sg sr_mod ide_cd_mod cdrom serio_raw acpi_memhotplug button tg3 libphy i2c_piix4 i2c_core pcspkr usb_storage uhci_hcd ohci_hcd ehci_hcd aacraid sd_mod scsi_mod ext3 jbd
> > > Pid: 5937, comm: cat Not tainted 2.6.29-tip-test #1 eserver xSeries 366-[88632RA]-
> > > RIP: 0010:[<ffffffff802d2258>]  [<ffffffff802d2258>] probe_wakeup_sched_switch+0xd1/0x1ae
> > > RSP: 0000:ffff8801cf4cdea0  EFLAGS: 00010046
> > > RAX: 0000000000000000 RBX: ffff88022f232820 RCX: 0000000000000046
> > > RDX: ffff8800281989a0 RSI: ffffffff8020d56d RDI: ffffffff811de480
> > > RBP: ffff8801cf4cded0 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000046
> > > R13: 0000000000000000 R14: ffff8801e4471820 R15: 0000000000000005
> > > FS:  00007f607411c6e0(0000) GS:ffff88002818b000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > CR2: 0000000000000008 CR3: 00000001da19a000 CR4: 00000000000006e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Process cat (pid: 5937, threadinfo ffff8801cf4cc000, task ffff8801e4471820)
> > > Stack:
> > >  ffff8800281989a0 ffff8802191e14b0 ffff88002819dd40 00007fff7c130640
> > >  0000000000000000 ffff88002819dd40 ffff8801cf4cdf70 ffffffff806f8264
> > >  0000000000000002 ffff8801cf4cdf48 ffff8801e4471820 ffff88022f232820
> > > Call Trace:
> > >  [<ffffffff806f8264>] schedule+0xd99/0x10f9
> > >  [<ffffffff806fb61b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> > >  [<ffffffff8020d56d>] retint_careful+0x12/0x2e
> > > Code: f2 83 3d 1b b0 9f 00 00 74 77 48 3b 1d a2 de f2 00 75 6e 48 8b 4d 00 48 8b 3d 8d de f2 00 45 89 e8 48 8b 01 48 8b 71 08 4c 89 e1 <48> 8b 50 08 e8 f7 9f ff ff 48 8b 3d 70 de f2 00 45 89 e8 48 89 
> > > RIP  [<ffffffff802d2258>] probe_wakeup_sched_switch+0xd1/0x1ae
> > >  RSP <ffff8801cf4cdea0>
> > > CR2: 0000000000000008
> > > ---[ end trace ab11daa90bb147ba ]---
> > > 
> > 
> > 
> > 
> > I've tested the same config and ran your script with wakeup tracer but nothing
> > weird happened.
> > Though I've tested on UP so may be I should try on SMP.
> 
> Yeah, that may make a difference ;-)

Looking at the code, I would say it is definitely SMP related. The issue 
is that he's reading the trace file over and over again. Reading the trace 
tries to stop the current tracer while it reads. When it stops reading, it 
restarts the tracer. This does a reset of the buffers. There is the wakeup 
lock that is suppose to protect it.

But I've changed this code slightly to allow the stopping to be done in 
atomic operations. Thus I no longer remove the trace points on a stop. 
This now changes the way things work since I first wrote the locking code. 
So I need to go back and review it to see if I've just opened up a race 
window.

Thanks for testing and reporting this!

-- Steve


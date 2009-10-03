Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZJCQBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZJCQBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbZJCQBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:01:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbZJCQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:01:21 -0400
Subject: Re: ftrace WARNING during boot
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091003112850.GC32486@mea-ext.zmailer.org>
References: <20091003105318.GB32486@mea-ext.zmailer.org>
	 <20091003110002.GA6162@nowhere>
	 <20091003112850.GC32486@mea-ext.zmailer.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 03 Oct 2009 11:59:21 -0400
Message-Id: <1254585561.12892.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 14:28 +0300, Matti Aarnio wrote:

> > >   .....................
> > >  kernel: rtc_cmos 00:04: setting system clock to 2009-10-02 23:21:17 UTC (1254525677)
> > >  kernel: Initalizing network drop monitor service
> > >  kernel: Freeing unused kernel memory: 3196k freed
> > >  kernel: NX-protecting the kernel data: ffffffff8150e000, 4469 pages
> > >  kernel: Write protecting the kernel read-only data: 7392k
> > >  kernel: dracut: dracut-002-2.gitc53acc30.fc12
> > >  kernel: udev: starting version 145
> > >  kernel: usb 1-5: new high speed USB device using ehci_hcd and address 4
> > >  kernel: ------------[ cut here ]------------
> > >  kernel: WARNING: at kernel/trace/ftrace.c:1003 ftrace_bug+0x198/0x27e() (Not tainted)
> > >  kernel: Hardware name: System Product Name
> > >  kernel: Modules linked in: i2c_core(+)
> > >  kernel: Pid: 87, comm: modprobe Not tainted 2.6.31-33.fc12.x86_64 #1
> > >  kernel: Call Trace:
> > >  kernel: [<ffffffff810642ec>] warn_slowpath_common+0x95/0xc3
> > >  kernel: [<ffffffffa0003072>] ? i2c_new_dummy+0x8/0x5e [i2c_core]
> > >  kernel: [<ffffffff81064341>] warn_slowpath_null+0x27/0x3d
> > >  kernel: [<ffffffff810d4ace>] ftrace_bug+0x198/0x27e
> > >  kernel: [<ffffffffa0003072>] ? i2c_new_dummy+0x8/0x5e [i2c_core]
> > >  kernel: [<ffffffff810d5d26>] ftrace_convert_nops+0x201/0x2b9
> > >  kernel: [<ffffffffa0003072>] ? i2c_new_dummy+0x8/0x5e [i2c_core]
> > >  kernel: [<ffffffff810d5e2a>] ftrace_module_notify+0x4c/0x7f
> > >  kernel: [<ffffffff81509c65>] notifier_call_chain+0x72/0xba
> > >  kernel: [<ffffffff81086e71>] ? __blocking_notifier_call_chain+0x4c/0x8e
> > >  kernel: [<ffffffff81086e88>] __blocking_notifier_call_chain+0x63/0x8e
> > >  kernel: [<ffffffff81086eda>] blocking_notifier_call_chain+0x27/0x3d
> > >  kernel: [<ffffffff810a472a>] sys_init_module+0xb7/0x249
> > >  kernel: [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b
> > >  kernel: ---[ end trace fbf9054ae0f212c7 ]---
> > >  kernel: ftrace faulted on writing [<ffffffffa0003072>] i2c_new_dummy+0x8/0x5e [i2c_core]

This means the update to modify the call to mcount to a nop failed.
Everything else passed (the read and compare). I think I saw some
patches go by that works on making the text in modules read only.

The ftrace update for text in core kernel makes the text writable for
the small window where we call kstop machine and update the text. Then
it makes that code read only again. At the time this code was written,
the modules were always read/write. If this has changed, I believe the
ftrace update needs to be fixed too.

-- Steve


> > >  kernel: usb 1-5: New USB device found, idVendor=0424, idProduct=2504
> > >  kernel: usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > >  kernel: usb 1-5: configuration #1 chosen from 1 choice
> > >  kernel: hub 1-5:1.0: USB hub found
> > >  kernel: hub 1-5:1.0: 4 ports detected



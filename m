Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYAORKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYAORKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYAORKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:10:33 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3742 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYAORKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:10:32 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc7-rt2
Date: Tue, 15 Jan 2008 18:10:27 +0100
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <1200336080.318.8.camel@localhost.localdomain> <200801142316.39330.m.kozlowski@tuxland.pl> <Pine.LNX.4.58.0801141730150.3109@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0801141730150.3109@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151810.28279.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > We are pleased to announce the 2.6.24-rc7-rt2 tree, which can be
> > > downloaded from the location:
> > >
> > >   http://rt.et.redhat.com/download/
> >
> > Compiles fine but I run into another problem. On startup kernel oopses
> > early and this 'oops' loops over and over again on the screen until you
> > shut down the box. So I can't (easily) capture the output. I tried different
> > boot_delay values but it seems that it doesn't work as intended. Seems that
> > it delays only the first printk from oops, then the rest loops over the screen
> > without delay - again it becomes unreadable. I used my usual config with a bunch
> > of debug options enabled so that maybe is not real rt system case. Also tried to
> > bisect it with quilt but that is hard. Lots of patches depends on another patches
> > so bisection brakes things. I'll look into this tommorow and reply if I get
> > anything substantial.
> >
> > I attached my config in case anybody wants to try to reproduce that.
> >
> 
> Turn off LOCKDEP and see if you still have the same problems. This might
> be fixed with Daniel's patch.

Ok. It works.

I found this in dmesg:

BUG: swapper:0 task might have lost a preemption check!
Pid: 0, comm: swapper Not tainted 2.6.24-rc7-rt2 #3
 [<c010386b>] show_trace_log_lvl+0x1d/0x3b
 [<c01042f3>] show_trace+0x12/0x14
 [<c0104a2f>] dump_stack+0x6a/0x70
 [<c0115419>] preempt_enable_no_resched+0x5c/0x5e
 [<c0100e35>] cpu_idle+0x6d/0x82
 [<c0323b6e>] rest_init+0x66/0x68
 [<c043aba6>] start_kernel+0x20c/0x276
 [<00000000>] 0x0
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

Box runs fine though.

Regards,

	Mariusz

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZGTXv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZGTXv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZGTXv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:51:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39165 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZGTXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:51:27 -0400
Date: Mon, 20 Jul 2009 19:51:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: s2r badness
In-Reply-To: <alpine.LFD.2.00.0907210101110.2813@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0907201948050.6743@gandalf.stny.rr.com>
References: <1247947383.4872.3.camel@laptop> <alpine.LFD.2.00.0907182223450.11571@localhost.localdomain> <alpine.DEB.2.00.0907201700010.14242@gandalf.stny.rr.com> <alpine.LFD.2.00.0907210101110.2813@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Jul 2009, Thomas Gleixner wrote:

> On Mon, 20 Jul 2009, Steven Rostedt wrote:
> > >  
> > > Just to make the list more complete. If tracing is enabled across
> > > suspend/resume you'll hit that one as well:
> > > 
> > > WARNING: at /home/tglx/work/kernel/git/linux-2.6/kernel/trace/ring_buffer.c:1392 rb_reserve_next_event+0x133/0x27c()
> > > 
> > > Negative timestamp delta which is probably due to sched_clock not yet
> > > adjusted to the TSC which got reset.
> > 
> > Perhaps we need to prevent tracing during a "blackout period" of suspend 
> > to ram?
> 
> Perhaps we need to figure out why this is happening and how we best
> deal with it. Disabling functionality just because we can not deal
> with it right now is not a solution.

Heh, suspend to ram is a black magic art. There's voodoo there that causes 
ulcers when you look the wrong way. For example, there's times that simply 
calling smp_processor_id() will reboot the box. Hence, the tracer is very 
intrusive, and we need to prevent it from doing things at certain areas. 
I'm not saying disabling functionality per say, I'm just saying that we 
need to make sure the tracer is not doing something in the guts of 
bringing the CPU back on line when it is not ready.

Are you saying that we need to move the initialization of sched_clock up, 
just to satisfy tracing? If that happens to be the issues here?

-- Steve


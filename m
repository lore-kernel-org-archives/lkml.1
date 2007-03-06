Return-Path: <linux-kernel-owner+w=401wt.eu-S933951AbXCFFjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbXCFFjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933958AbXCFFjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:39:54 -0500
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:39319 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933951AbXCFFjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:39:53 -0500
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free   interactive
	cpu scheduler
From: Nicholas Miell <nmiell@comcast.net>
To: Willy Tarreau <w@1wt.eu>
Cc: Con Kolivas <kernel@kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       jos poortvliet <jos@mijnkamer.nl>, ck@vds.kolivas.org,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070306044112.GA10707@1wt.eu>
References: <200703041800.53360.kernel@kolivas.org>
	 <200703041708.54953.jos@mijnkamer.nl> <45ECA239.5000306@tmr.com>
	 <200703061118.44616.kernel@kolivas.org>  <20070306044112.GA10707@1wt.eu>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 21:39:35 -0800
Message-Id: <1173159575.2987.2.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 05:41 +0100, Willy Tarreau wrote:
> On Tue, Mar 06, 2007 at 11:18:44AM +1100, Con Kolivas wrote:
> > On Tuesday 06 March 2007 10:05, Bill Davidsen wrote:
> > > jos poortvliet wrote:
> > > > Well, imho his current staircase scheduler already does a better job
> > > > compared to mainline, but it won't make it in (or at least, it's not
> > > > likely). So we can hope this WILL make it into mainline, but I wouldn't
> > > > count on it.
> > >
> > > Wrong problem, what is really needed is to get CPU scheduler choice into
> > > mainline, just as i/o scheduler finally did. Con has noted that for some
> > > loads this will present suboptimal performance, as will his -ck patches,
> > > as will the default scheduler. Instead of trying to make ANY one size
> > > fit all, we should have a means to select, at runtime, between any of
> > > the schedulers, and preferably to define an interface by which a user
> > > can insert a new scheduler in the kernel (compile in, I don't mean
> > > plugable) with clear and well defined rules for how that can be done.
> > 
> > Been there, done that. Wli wrote the infrastructure for plugsched; I took his 
> > code and got it booting and ported 3 or so different scheduler designs. It 
> > allowed you to build as few or as many different schedulers into the kernel 
> > and either boot the only one you built into your kernel, or choose a 
> > scheduler at boot time. That code got permavetoed by both Ingo and Linus. 
> > After that I gave up on that code and handed it over to Peter Williams who 
> > still maintains it. So please note that I pushed the plugsched barrow 
> > previously and still don't think it's a bad idea, but the maintainers think 
> > it's the wrong approach.
> 
> In a way, I think they are right. Let me explain. Pluggable schedulers are
> useful when you want to switch away from the default one. This is very useful
> during development of a new scheduler, as well as when you're not satisfied
> with the default scheduler. Having this feature will incitate many people to
> develop their own scheduler for their very specific workload, and nothing
> generic. It's a bit what happened after all : you, Peter, Nick, and Mike
> have worked a lot trying to provide alternative solutions.
> 
> But when you think about it, there are other OSes which have only one scheduler
> and which behave very well with tens of thousands of tasks and scale very well
> with lots of CPUs (eg: solaris). So there is a real challenge here to try to
> provide something at least as good and universal because we know that it can
> exist. And this is what you finally did : work on a scheduler which ought to be
> good with any workload.

Solaris has a pluggable scheduler framework (each policy --
OTHER/FIFO/RR/etc. -- is it's own separate component).

-- 
Nicholas Miell <nmiell@comcast.net>


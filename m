Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZHQOtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZHQOtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZHQOtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:49:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZHQOtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:49:01 -0400
Date: Mon, 17 Aug 2009 10:49:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Johannes Stezenbach <js@sig21.net>
cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
In-Reply-To: <20090811154006.GA5315@sig21.net>
Message-ID: <alpine.DEB.2.00.0908171041160.20915@gandalf.stny.rr.com>
References: <87k51cgdt8.fsf@basil.nowhere.org> <20090810122731.GA5863@sig21.net> <20090810123228.GD6838@basil.fritz.box> <20090810125651.GB6082@sig21.net> <20090810132923.GA4418@elte.hu> <20090810192658.GA15513@sig21.net> <20090810201406.GA6961@elte.hu>
 <20090810203706.GA17338@sig21.net> <20090810213133.GB16944@elte.hu> <20090810221307.GA19236@sig21.net> <20090811154006.GA5315@sig21.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Aug 2009, Johannes Stezenbach wrote:

> On Tue, Aug 11, 2009 at 12:13:07AM +0200, Johannes Stezenbach wrote:
> > On Mon, Aug 10, 2009 at 11:31:33PM +0200, Ingo Molnar wrote:
> > > * Johannes Stezenbach <js@sig21.net> wrote:
> > > > 
> > > > Could the warning be caused by the cpufreq ondemand governor? ISTR 
> > > > that one should switch to the performance governor before doing 
> > > > any profiling, but I forgot for this test.
> > > 
> > > there might be a connection - it could in theory cause sched_clock() 
> > > transients and confuse the ring-buffer time-stamping.
> > 
> > I'll try tomorrow after a fresh boot if the warning also appears
> > with the performance governor.
> 
> Nope, cpufreq was not the culprit.  The "Delta way too big!"
> warning in rb_reserve_next_event() happens after suspend-to-RAM.

Yeah, the ring buffer expects the time delta of two different events on 
the same page to be less than 2^59 nanosecs apart. But something must have 
screwed things up, since 2^59 nanosecs is 6671 days (18 years).

Perhaps coming out of suspend to ram changes the timestamp? Does it reset 
the result of sched_clock?

-- Steve


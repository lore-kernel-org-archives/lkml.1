Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbXCMUfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbXCMUfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933266AbXCMUfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:35:54 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:55804
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbXCMUfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:35:54 -0400
Date: Tue, 13 Mar 2007 13:35:49 -0700
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313203549.GB9520@gnuppy.monkey.org>
References: <MDEHLPKNGKAHNMBLJOLKIELACDAC.davids@webmaster.com> <45F70540.8090506@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F70540.8090506@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 01:10:40PM -0700, Jeremy Fitzhardinge wrote:
> David Schwartz wrote:
> Hm, well.  The general preference has been for the kernel to do a
> good-enough job on getting the common cases right without tuning, and
> then only add knobs for the really tricky cases it can't do well.  But
> the impression I'm getting here is that you often get sucky behaviours
> without tuning.

Well, you get strict behaviors as expected for this scheduler. 

> > I think it's completely irrational to ask for a scheduler that automatically
> > gives more CPU time to CPU hogs.
> >   
> 
> Well, it doesn't have to.  It could give good low latency with short
> timeslices to things which appear to be interactive.  If the interactive
> program doesn't make good use of its low latency, then it will suck. 
> But that's largely independent of how much overall CPU you give it.

This is way beyond what SCHED_OTHER should do. It can't predict the universe.
Much of the interactivity estimator borders on magic. It just happens to
also "be a good fit" for hacky apps as well almost by accident.

> > I agree. I'm not claiming to have the perfect solution. Let's not let the
> > perfect be the enemy of the good though.
> 
> For all its faults, the current scheduler mostly does a good job without
> much tuning - I normally only use "nice" to run cpu-bound things without
> jacking the cpu speed up.  Certainly in my normal interactive use of
> compiz vs make -j4 on a dual-core generally gets pretty pretty good
> results.  I plan on testing the new scheduler soon though.

We can do MUCH better in the long run with something like Con's scheduler.
His approach shouldn't be dismissed because it's running into a relatively
few minor snags large the fault of scheduleing opaque applications. It's
precise enough that it can also be loosened up a bit with additional
control terms (previous email).

It might be good to think about that a bit to see if a schema like this can
be made more adaptable for the environment it serves. You'd then have both
precisely bounded control over CPU usage and enough flexibility for burstly
needs of certain apps.

bill


Return-Path: <linux-kernel-owner+w=401wt.eu-S1422906AbXBAOtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906AbXBAOtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXBAOtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:49:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:32951 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422906AbXBAOte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:49:34 -0500
Date: Thu, 1 Feb 2007 15:52:43 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Message-ID: <20070201145236.GA23394@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <200702011220.59484.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011220.59484.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:20:59PM +0100, Andi Kleen wrote:
> On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> 
> > 
> > Inter-CPU monotonicity can not, however, be guaranteed in a vsyscall, so
> > vsyscall is not used by default.
> 
> Only for unsynchronized machines I hope 

yes, sorry, only on unsynchronized machines

> The big strategic problem is how to marry your patchkit to John Stultz's
> clocksources work which is also competing for merge. Any thoughts on that? 

I'll look into that next week. Sorry, I wanted to do that a long time
ago, but I spent weeks (over a month) fighting a nasty livelock
in the code. (Morale: think twice before using a spinlock inside
                      a {do .. while (read_seqretry(..))} loop)

> >When strict inter-CPU monotonicity is not needed, the vsyscall version of
> >gettimeofday may be forced using the "nomonotonic" command line parameter.
> >gettimeofday()'s monotonicity is guaranteed on a single CPU even with the very
> >fast vsyscall version.  Across CPUs, the vsyscall version of gettimeofday is
> >not guaranteed to be monotonic, but it should be pretty close. Currently, we
> >get errors of tens/hundreds of microseconds.
> 
> I think a better way to do this would be to define a new CLOCK_THREAD_MONOTONOUS
> (or better name) timer for clock_gettime(). 

I absolutely agree. Will do that. This should give userspace a
decently accurate and very fast time source.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ


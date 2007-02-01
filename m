Return-Path: <linux-kernel-owner+w=401wt.eu-S1422850AbXBATlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850AbXBATlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422959AbXBATlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:41:24 -0500
Received: from styx.suse.cz ([82.119.242.94]:41576 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422850AbXBATlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:41:23 -0500
Date: Thu, 1 Feb 2007 20:41:09 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: john stultz <johnstul@us.ibm.com>
Cc: Jiri Bohac <jbohac@suse.cz>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, arjan@infradead.org,
       tglx@linutronix.de, zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Message-ID: <20070201194109.GA21971@suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <200702011220.59484.ak@suse.de> <20070201145236.GA23394@dwarf.suse.cz> <1170349008.2558.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170349008.2558.9.camel@localhost>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 08:56:48AM -0800, john stultz wrote:
> On Thu, 2007-02-01 at 15:52 +0100, Jiri Bohac wrote:
> > On Thu, Feb 01, 2007 at 12:20:59PM +0100, Andi Kleen wrote:
> >>
> > > The big strategic problem is how to marry your patchkit to John Stultz's
> > > clocksources work which is also competing for merge. Any thoughts on that? 
> > 
> > I'll look into that next week. Sorry, I wanted to do that a long time
> > ago, but I spent weeks (over a month) fighting a nasty livelock
> > in the code. (Morale: think twice before using a spinlock inside
> >                       a {do .. while (read_seqretry(..))} loop)
> 
> The first step here shouldn't be too difficult. Just create a _read
> function that uses your code to return monotonic TSC cycles (instead of
> nanoseconds w/ gettimeofday).  Then just create a clocksource structure
> for it.

guess_mt() is more or less the function you're looking for. (With the
exception of the cpufreq and mode switching logic.)

> The harder part will be the vsyscall, as you will need extra per cpu
> data in the vsyscall read. I had some test code for this situation
> awhile back, so if you get the first part functioning correctly (just a
> clocksource w/o a vread pointer), I'll gladly help you get the vsyscall
> bits working.
> 
> thanks
> -john
> 
> 

-- 
Vojtech Pavlik
Director SuSE Labs

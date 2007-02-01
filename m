Return-Path: <linux-kernel-owner+w=401wt.eu-S1422824AbXBALhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824AbXBALhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422823AbXBALhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:37:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:56479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817AbXBALgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:36 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Date: Thu, 1 Feb 2007 12:20:59 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz>
In-Reply-To: <20070201095952.589234000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011220.59484.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:

> 
> Inter-CPU monotonicity can not, however, be guaranteed in a vsyscall, so
> vsyscall is not used by default.

Only for unsynchronized machines I hope 

> Still, the syscall version of gettimeofday is 
> a lot faster using the TSC approximation instead of other hardware timers.

Yes that makes sense.

The big strategic problem is how to marry your patchkit to John Stultz's
clocksources work which is also competing for merge. Any thoughts on that? 

>When strict inter-CPU monotonicity is not needed, the vsyscall version of
>gettimeofday may be forced using the "nomonotonic" command line parameter.
>gettimeofday()'s monotonicity is guaranteed on a single CPU even with the very
>fast vsyscall version.  Across CPUs, the vsyscall version of gettimeofday is
>not guaranteed to be monotonic, but it should be pretty close. Currently, we
>get errors of tens/hundreds of microseconds.

I think a better way to do this would be to define a new CLOCK_THREAD_MONOTONOUS
(or better name) timer for clock_gettime(). 

[and my currently stalled vdso patches that implement clock_gettime
as a vsyscall]

Then also an application could easily use it with LD_PRELOAD

-Andi

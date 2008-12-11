Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYLKSV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYLKSV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYLKSVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:21:47 -0500
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:56663 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755082AbYLKSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:21:46 -0500
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 13:21:45 EST
Date: Thu, 11 Dec 2008 13:02:33 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
In-Reply-To: <20081211155230.GA4230@elte.hu>
Message-ID: <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
References: <20081211155230.GA4230@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can someone tell me which performance counter implementation is likely to 
get merged into the Kernel?

I have at least 60 machines that I do regular performance counter work on. 
They involve Pentium Pro, Pentium II, 32-bit Athlon, 64-bit Athlon, 
Pentium 4, Pentium D, Core, Core2, Atom, MIPS R12k, Niagara T1, 
and PPC/Playstation 3.

Perfmon3 works for all of those 60 machines.  This new proposal works on a 
2 out of the 60.

Who is going to add support for all of those machines?  I've spent a lot 
of developer time getting prefmon going for all of those configurations. 
But why should I help out with this new inferior proposal?  It could all 
be another waste of time.

So I'd like someone to commit to some performance monitoring architecture. 
Otherwise we're going to waste thousands of hours of developer time around 
the world.  It's all pointless.

Also, my primary method of using counters is total aggregate count for a 
single user-space process.  So I use perfmon's pfmon tool to run an entire 
lon-running program, gathering full stats only at the very end.  pfmon can 
do this with pretty much zero overhead (I have lots of data and a few 
publications using this method).  Can this new infrastructure to this?  I 
find the documentation/tools support to be very incomplete.

One comment on the patch.


> +	/*
> +	 * Common hardware events, generalized by the kernel:
> +	 */
> +	PERF_COUNT_CYCLES		=  0,
> +	PERF_COUNT_INSTRUCTIONS		=  1,
> +	PERF_COUNT_CACHE_REFERENCES	=  2,
> +	PERF_COUNT_CACHE_MISSES		=  3,
> +	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
> +	PERF_COUNT_BRANCH_MISSES	=  5,

Many machines do not support these counts.  For example, Niagara T1 does 
not have a CYCLES count.  And good luck if you think you can easily come 
up with something meaningful for the various kind of CACHE_MISSES on the 
Pentium 4.  Also, the Pentium D has various flavors of retired instruction 
count with slightly different semantics.  This kind of abstraction should 
be done in userspace.

Vince

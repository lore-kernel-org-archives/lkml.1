Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbXEYHio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbXEYHio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXEYHii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:38:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41715 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbXEYHih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:38:37 -0400
Date: Fri, 25 May 2007 09:38:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups
Message-ID: <20070525073836.GC8094@one.firstfloor.org>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525072512.GA12683@elte.hu> <20070525072641.GA13025@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525072641.GA13025@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 09:26:41AM +0200, Ingo Molnar wrote:
> 
> > > if (!f)
> > > 	f = cpufreq_get(freq->cpu);
> > > if (!f)
> > > 	f = tsc_khz;
> > > 
> > > ?
> > > 
> > > Something's not quite right here :-)
> 
> ah, that's fine. It does this: 'try to give f a value', and then: 'if 
> still no value then give it tsc_khz as a last resort)
> 
> call_r_s_f() still needs an urgent rerenaming though =B-)

The whole thing would be much simpler if

- cpu up callbacks had a way to request executing on the target CPU
[i looked at this, but it was a little more involved than a simple
cleanup]
- smp_call_function_single had sane semantics regarding calling
the same CPU similar to on_each_cpu()
- C had anonymous lambda functions with nice syntax (ok one can dream) 

But right now so many callbacks are needed that I ran out of good
names.

-Andi


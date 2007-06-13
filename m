Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbXFMVvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbXFMVvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXFMVuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:50:55 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34326 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969AbXFMVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:50:55 -0400
Date: Wed, 13 Jun 2007 23:51:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070613215104.GK3588@stusta.de>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070604190102.GY5500@stusta.de> <20070613155724.GA8703@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070613155724.GA8703@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 11:57:24AM -0400, Mathieu Desnoyers wrote:
> Hi Adrian,

Hi Mathieu,

>...
> > 2. What is the real-life performance improvement?
> > That micro benchmarks comparing cache hits with cache misses give great 
> > looking numbers is obvious.
> > But what will be the performance improvement in real workloads after the
> > functions you plan to make conditional according to question 1 have been 
> > made conditional?
> 
> Hrm, I am trying to get interesting numbers out of lmbench: I just ran a
> test on a kernel sprinkled with about 50 markers at important sites
> (LTTng markers: system call entry/exit, traps, interrupt handlers, ...).
> The markers are compiled-in, but in "disabled state". Since the markers
> re-use the cond_call infrastructure, each marker has its own cond_call.
>...
> The results are that we really cannot tell that one is faster/slower
> than the other; the standard deviation is much higher than the
> difference between the two situations.
> 
> Note that lmbench is a workload that will not trigger much L1 cache
> stress, since it repeats the same tests many times. Do you have any
> suggestion of a test that would be more representative of a real
> diversified (in term of in-kernel locality of reference) workload ?

Please correct me if I'm wrong, but I think 50 markers couldn't ever 
result in a visible change:

You need a change that is big enough that it has a measurable influence 
on the cache hit ratio.

I don't think you could get any measurable influence unless you get into 
areas where > 10% of all code are conditional. And that's a percentage 
I wouldn't consider being realistically.

And one big disadvantage of your implementation is the dependency on 
MODULES. If you build all driver statically into the kernel, switching 
from CONFIG_MODULES=y to CONFIG_MODULES=n already gives you for free a 
functionally equivalent kernel that is smaller by at about 8% (depending 
on the .config).

My impression is that your patches would add an infrastructure for a 
nice sounding idea that will never have any real life effect.

> Thanks,
> 
> Mathieu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXHaNTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXHaNTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932073AbXHaNT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:19:27 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3036 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337AbXHaNT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:19:26 -0400
Date: Fri, 31 Aug 2007 15:19:56 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <20070831105447.GA17956@elte.hu>
Message-ID: <Pine.LNX.4.64.0708311341510.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <20070831105447.GA17956@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 31 Aug 2007, Ingo Molnar wrote:

> So the most intrusive (math) aspects of your patch have been implemented 
> already for CFS (almost a month ago), in a finegrained way.

Interesting claim, please substantiate.

> Peter's patches change the CFS calculations gradually over from
> 'normalized' to 'non-normalized' wait-runtime, to avoid the
> normalizing/denormalizing overhead and rounding error.

Actually it changes wait-runtime to a normalized value and it changes 
nothing about the rounding error I was talking about.
It addresses the conversion error between the different units I was 
mentioning in an earlier mail, but the value is still rounded.

> > This model is far more accurate than CFS is and doesn't add an error 
> > over time, thus there are no more underflow/overflow anymore within 
> > the described limits.
> 
> ( your characterisation errs in that it makes it appear to be a common
>   problem, while in practice it's only a corner-case limited to extreme 
>   negative nice levels and even there it needs a very high rate of 
>   scheduling and an artificially constructed workload: several hundreds 
>   of thousand of context switches per second with a yield-ing loop to be 
>   even measurable with unmodified CFS. So this is not a 2.6.23 issue at 
>   all - unless there's some testcase that proves the opposite. )
> 
> with Peter's queue there are no underflows/overflows either anymore in 
> any synthetic corner-case we could come up with. Peter's queue works 
> well but it's 2.6.24 material.

Did you even try to understand what I wrote?
I didn't say that it's a "common problem", it's a conceptual problem. The 
rounding has been improved lately, so it's not as easy to trigger with 
some simple busy loops.
Peter's patches don't remove limit_wait_runtime() and AFAICT they can't, 
so I'm really amazed how you can make such claims.

> All in one, we dont disagree, this is an incremental improvement we are 
> thinking about for 2.6.24. We do disagree with this being positioned as 
> something fundamentally different though - it's just the same thing 
> mathematically, expressed without a "/weight" divisor, resulting in no 
> change in scheduling behavior. (except for a small shift of CPU 
> utilization for a synthetic corner-case)

Everytime I'm amazed how quickly you get to your judgements... :-(
Especially interesting is that you don't need to ask a single question for 
that, which would mean you actually understood what I wrote, OTOH your 
wild claims tell me something completely different.

BTW who is "we" and how is it possible that this meta mind can come to 
such quick judgements?

The basic concept is quite different enough, one can e.g. see that I have
to calculate some of the key CFS variables for the debug output.
The concepts are related, but they are definitively not "the same thing 
mathematically", the method of resolution is quite different, if you think 
otherwise then please _prove_ it.

bye, Roman

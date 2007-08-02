Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXHBWis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXHBWis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbXHBWik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:38:40 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3753 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436AbXHBWij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:38:39 -0400
Date: Fri, 3 Aug 2007 00:38:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070802160906.GA20377@elte.hu>
Message-ID: <Pine.LNX.4.64.0708022101580.1817@scrub.home>
References: <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0708011525560.1817@scrub.home>
 <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
 <20070802160906.GA20377@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2 Aug 2007, Ingo Molnar wrote:

> Most importantly, CFS _already_ includes a number of measures that act 
> against too frequent math. So even though you can see 64-bit math code 
> in it, it's only rarely called if your clock has a low resolution - and 
> that happens all automatically! (see below the details of this buffered 
> delta math)
> 
> I have not seen Roman notice and mention any of these important details 
> (perhaps because he was concentrating on finding faults in CFS - which a 
> reviewer should do), but those measures are still very important for a 
> complete, balanced picture, especially if one focuses on overhead on 
> small boxes where the clock is low-resolution.
> 
> As Peter has said it in his detailed review of Roman's suggested 
> algorithm, our main focus is on keeping total complexity down - and we 
> are (of course) fundamentally open to changing the math behind CFS, we 
> ourselves tweaked it numerous times, it's not cast into stone in any 
> way, shape or form.

You're comparing apples with oranges, I explicitely said:

"At this point I'm not that much interested in a few localized 
optimizations, what I'm interested in is how can this optimized at the 
design level"

IMO it's very important to keep computational and algorithmic complexity 
separately, I want to concentrate on the latter, so unless you can _prove_ 
that a similiar set of optimizations is impossible within my example, I'm 
going to ignore them for now. CFS has already gone through several 
versions of optimization and tuning, expecting the same from my design 
prototype is a little confusing...

I want to analyze the foundation CFS is based on, in the review I 
mentioned a number of other issues and design related questions. If you 
need more time, that's fine, but I'd appreciate more background 
information related to that and not that you only jump on the more trivial 
issues.

> In Roman's variant of CFS's algorithm the variables are 32-bit, but the 
> error is rolled forward in separate fract_* (fractional) 32-bit 
> variables, so we still have 32+32==64 bit of stuff to handle. So we 
> think that in the end such a 32+32 scheme would be more complex (and 
> anyone who took a look at fs2.c would i think agree - it took Peter a 
> day to decypher the math!)

Come on, Ingo, you can do better than that, I did mention in my review 
some of the requirements for the data types.
I'm amazed how you can get to that judgement so quickly, could you please 
substantiate that a little more?

I admit that the lack of source comments is an open invitation for further 
questions and Peter did exactly this and his comments were great - I'm 
hoping for more like that. You OTOH jump to conclusions based on a partial 
understanding what I'm actually trying to do.
Ingo, how about you provide some of the mathematical prove CFS is based 
on? Can you prove that the rounding errors are irrelevant? Can you prove 
that all the limit checks can have no adverse effect? I tried that and I'm 
not entirely convinced of that, but maybe it's just me, so I'd love to see 
someone else's attempt at this.
A major goal of my design is it to be able to define the limits within the 
scheduler is working correctly, so I know which information is relevant 
and what can be approximated.

bye, Roman

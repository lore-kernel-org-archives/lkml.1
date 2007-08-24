Return-Path: <linux-kernel-owner+w=401wt.eu-S933337AbXHXSLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbXHXSLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933268AbXHXSKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:10:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933205AbXHXSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:10:08 -0400
Date: Fri, 24 Aug 2007 11:09:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull request] scheduler updates
In-Reply-To: <20070824141215.GA24403@elte.hu>
Message-ID: <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org>
References: <20070824141215.GA24403@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Aug 2007, Ingo Molnar wrote:
> 
> Then there's also a change/tweak that increases the default granularity: 
> it's still well below human perception so should not be noticeable, but 
> servers win a bit from less preemption of CPU-bound tasks. (this is also 
> the first step towards eliminating HZ from the granularity default 
> calculation.)

Your explanation makes NO sense.

It doesn't eliminate HZ at all. It's still there, and it's still totally 
bogus.

Please just *remove* that thing. It has no possible value! You claim that 
the preemption granularity is in "ns", and that it defaults to "3 msec", 
but it does no such thing at all, even with your patch. It does:

	unsigned int sysctl_sched_granularity __read_mostly = 3000000000ULL/HZ;

which is just total and utter CRAP!

Why the hell can't you just make the code sane and do what the comment 
*says* it does, and just admit that HZ has nothing what-so-ever to do with 
that thing, and then you do

	unsigned int sysctl_sched_granularity __read_mostly = 3000000ULL;

and be done with it. Instead of this *insane* expectation that HZ is 
always 1000, and any other value means that you want bigger granularity, 
which is not true and makes no sense.

So dammit, stop writing these totally bogus "explanations". If you have a 
reason why the granularity needs to be HZ-dependent, *document* that 
reason, and make the code actually match the comment, instead of 
continually documenting things that SIMPLY ARE NOT TRUE.

Ingo, I'm not going to pull this kind of antics and crap.

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZFKUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZFKUYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZFKUYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:24:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZFKUYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:24:02 -0400
Date: Thu, 11 Jun 2009 22:23:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611202341.GA23590@elte.hu>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com> <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

[...]
> What the "keep it in the kernel sources" approach hopefully allows is
> 
>  - taking advantage of new features in a timely manner.
> 
>    NOT with some ABI breakage, but simply things like supporting a 
>    new CPU architecture or new counters. The thing that oprofile 
>    failed at so badly in my experience.
>
>  - Make it easier for developers, and _avoiding_ the horrible 
>    situation where you have two different groups that don't talk 
>    well to each other because one is a group of user-space 
>    weenies, and the other is a group of manly kernel people, and 
>    there is no common ground.

Yes, very much agreed.

Btw., here are a couple of other arguments why i find it useful to 
have the tools/perf/ in the kernel repo:

1) Super-fast and synchronized release cycles

The kernel is one of the fastest moving packages in Linux - most 
user-space packages have (much!) longer release cycles than 3 
months.

A tight release schedule forces a certain amount of release 
discipline on tooling as well - so i'm glad that the two will be 
coupled. It's so easy for a promising tool to degrade into 
tinkerware with odd release cycles with time - if it's part of the 
kernel then at least the release cycles wont be odd but at precise 3 
months.

2) Performance _matters_

This is an argument pretty specific to perfcounters: Performance 
analysis tools under Linux suck pretty summarily. Yet, one of the 
major strengths of Linux is (or at least used to be) performance. So 
i find it very fitting that the kernel community takes performance 
analysis tooling into their own hand.

3) Strict quality control under a proven mode

In the kernel repo i can be sure that:

  - No one will even think of adding autofools to tools/perf/.

  - No one will send us code with Hungarian notation and two spaces
    tabulation.

  - No one will put getopt.h into the code

  - No one will rewrite it in some weird language

   [ Or at least, even though such incidents might happen 
     occasionally, i can just sit back in my chair and watch the
     resulting showdown on lkml, without having to worry about the 
     outcome ;-) ]

I can point contributors to well-established kernel coding 
principles, without having to argue no end about them.

All in one - the Linux kernel is a fire breathing monster engine 
when it comes to producing good software. Who says it that that this 
infrastructure and experience can only be used to produce kernel 
space code?

4) Code reuse

We actually use code from the kernel: list.h primitives and 
rbtrees.c. We privatized them for now under 
tools/perf/util/rbtree.[ch] and tools/perf/util/list.h because 
there's some header and type pollution in them, but it would be nice 
to include them directly and share the facilities.

5) Reality check for kernel developers

I think kernel hackers need a reality check too. It's easy to say 
that user-space sucks - but now there's a way and channel that 
frustration via direct action and make a real difference. I do hope 
that the extra superfluous mental energies visible in this thread 
can be used for good purposes too ;-)

6) It's a lot of fun

I never thought i'd say that - but hacking properly structured 
user-space code in the kernel repo is serious fun. It's even 
relaxing at times: i can be reasonably sure that i wont crash the 
kernel.

All in one, we did this because we found that it produces better 
code in practice and does it faster - and i dont think we should 
rigidly limit the kernel repo to kernel-space projects alone.

	Ingo

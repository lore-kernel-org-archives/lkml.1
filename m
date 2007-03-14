Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbXCNNla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbXCNNla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933904AbXCNNla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:41:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811AbXCNNl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:41:29 -0400
Date: Wed, 14 Mar 2007 14:41:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314134112.GB13486@elte.hu>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <1173879210.31159.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173879210.31159.30.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > i agree. We've recently factored out quite a bit of common code 
> > between i386 and x86_64 recently: genirq, gtod/clocksource and 
> > clockevents.
> 
> But those are things that can mostly be shared across all archs.

yeah.

> > and that's how i think unification of architectures should be done: 
> > move code into kernel/* and drivers/*, _not_ into another 
> > architecture. That way all architectures benefit.
> 
> I'm OK with it, although I did waste a lot of effort making those 
> patches (But I speak better in C than in English, or any other verbal 
> language, so it wasn't that bad). But if you look at the code that was 
> merged, I'm not sure many other archs will benefit. How many archs use 
> mtrr's? Perhaps these still can go into the drivers directory with a 
> bit of work. Don't know, I'm not that close to that code to be sure, 
> and don't have the time to find out ATM.

hm. Do you have any numbers handy - what is the end-result of your 
unification work, how many lines of code were unified, compared to the 
total body of code in i386 and x86_64?

> But at least there needs to be a more common way to share files 
> between the two archs. Having a file with just a single line of:
> 
> #include "../../i386/kernel/mycommoncode.c"
> 
> is not that elegant. The make files are, perhaps, a bit better.

yeah, that #include file thing for early_printk.c is just gross.

> Another thing that happens a lot with these shared funcs in these 
> files, is finding them . Since "make TAGS" doesn't bother to check 
> i386 when run with ARCH=x86_64. The first time I searched for 
> early_printk while developing i386 took me an hour, since my search 
> scripts don't check other archs (I've changed that since).  I thought 
> that the function was one of these macro created functions, and was 
> non-arch specific (didn't look into arch).
> 
> So, when creating new shared code, what's the "proper" way?

symbolic links perhaps? In that case i'd also introduce a common naming 
scheme: x86_early_printk.c - to make sure we know it right away that 
those files are bi-arch.

	Ingo

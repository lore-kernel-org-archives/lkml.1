Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbXCNUUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbXCNUUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXCNUUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:20:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbXCNUUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:20:41 -0400
Date: Wed, 14 Mar 2007 21:19:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314201944.GA11583@elte.hu>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <20070314180933.GA12994@elte.hu> <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org> <20070314195916.GA5674@elte.hu> <20070314200704.GB376@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314200704.GB376@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > Andrew's laptop only half a dozen times! ;) But .. in the long run, 
> > it's alot easier to think about unified code. 32-bit x86 will 
> > certainly stay with us for at least 10-20 years, and the best model 
> > for maintainance is having one codebase.
> 
> Not sure -- i'm often glad I don't have to care about all the old 
> 32bit systems on x86-64. [...]

the basic dynamics of legacies does not change if we have only 50% of 
them: right now x86_64 is just growing its own set of legacies, at the 
same rate as i386 did it 10 years ago. That makes little difference in 
practice: those legacies will quickly necessiate the _same_ kinds of 
abstractions that allow the flexible injection of hardware-dependent 
quirks. In another 5 years the x86_64 tree will end up looking and 
behaving _just like the i386_ tree, the only difference will be less 
compatibility. (In fact, it will likely look worse because currently our 
efforts are 50% split between i386 and x86_64, and the random 
differences between the two arches are wasting developer resources.)

so we might as well unify the two trees and /learn/ from i386's 
legacies, while integrating them. Those legacies, by the rule of large 
numbers, will revisit x86_64 too (or have already visited it). We 
already have per-APIC-version quirks, per CPU model quirks, etc., etc. 
The main cost of a quirk is the abstraction it necessiates, not the 
quirk handler itself. (which, once the framework is there, is modular)

Also, 90% of our users are still running 32bit kernels _even on 64-bit 
capable hardware_, so we might as well prepare ourselves for a really 
long march towards a pure 64-bit world. (Which will likely never come.)

	Ingo

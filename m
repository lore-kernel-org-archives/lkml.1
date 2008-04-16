Return-Path: <linux-kernel-owner+w=401wt.eu-S1762402AbYDPMij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402AbYDPMij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYDPMia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:38:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbYDPMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:38:30 -0400
Date: Wed, 16 Apr 2008 14:37:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080416123732.GA32527@elte.hu>
References: <4803AD91.5020001@firstfloor.org> <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com> <1208242017.7053.4.camel@lappy> <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org> <20080415170556.GA16417@elte.hu> <20080415185008.GE9191@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415185008.GE9191@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Apr 15, 2008 at 07:05:56PM +0200, Ingo Molnar wrote:
>
> > i very much agree with the "get rid of semaphores" argument - the 
> > reason why i initially supported the "move to generic semaphores" 
> > step was because i saw it basically as the precursor to full 
> > removal: it is the removal of semaphores from all architectures - 
> > with a small generic compatibility wrapper to handle the remaining 
> > few uses of semaphores.
> 
> Hm.  I thought you initially supported it because it deleted so much 
> code. [...]

... sorry, but i always thought of semaphores to be removed completely.

> [...]  I don't want to go and add down_killable() to each architecture 
> again, and you were pretty enthusiastic about adding down_killable().

... the killable sleeps should and are already propagated everywhere - i 
never thought of them as a semaphore-only feature.

killable sleeps are probably the next best thing to true 
interruptability.

btw., has anyone thought about killable sync/fsync syscalls - would that 
surprise too many programs?

> > i got thoroughly surprised by the "increase the scope of semaphores" 
> > angle to the patchset though, and in hindsight i'd rather see 
> > neither of those generalizations and see semaphores die a slow but 
> > sure natural death than to see their prolongation :-/
> 
> I'm fully in favour of reducing the number of semaphore users, and 
> eventually eliminating them.  Arjan and I discussed a way to do that 
> just now ... I'll write some code, see how it looks.

cool!

	Ingo

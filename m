Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbYDNPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbYDNPk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYDNPkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:40:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYDNPkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:40:19 -0400
Date: Mon, 14 Apr 2008 17:39:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080414153928.GA22259@elte.hu>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org> <20080413070833.GC19773@elte.hu> <20080413125758.GQ11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413125758.GQ11962@parisc-linux.org>
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

> On Sun, Apr 13, 2008 at 09:08:33AM +0200, Ingo Molnar wrote:
> > but semaphores will be _removed_, _completely_. Rewriting them in 
> > generic C code is just the first step towards that - it consolidates all 
> > the myriads of semaphore implementations that Linux has spread out.
> 
> I think you're dreaming. [...]

no, i'm hoping for a simpler and thus more maintainable kernel.

> [...]  We have 11 places in the tree that currently demand to use a 
> counting semaphore (with 'n' plausibly greater than 1). [...]

which ones exactly are these places that demand the use of a counting 
semaphore? I cannot think of a single place where it's the best choice, 
let alone one where it's the only choice.

And if there's just 5 isolated places in the kernel that would need a 
different locking primitive then i say that it's probably not worth it. 
Locking is at the center of every data structure and the clarity and 
simplicity of basic data structure operations is paramount IMHO. 

Semaphores are i think a relic from the days when people thought that 
parallelism can be best achieved via complexity and rafinery of locking 
primitives - regardless of how usable and debuggable those APIs end up 
to be. Today we can go extremely parallel with very simple and robust 
primitives.

> [...] If we remove the facility, these places are going to invent 
> their own weird locking schemes.

i'm not worried about weird locking anymore - lockdep tends to expose 
them rather nicely and the lack of lockdep coverage for open-coded 
locking schemes tends to be a barrier as well. The past 2 years have 
shown that people want lockdep coverage for just about everything where 
it can be applied: workqueues, special locks, etc. (there's even 
questions about whether it could be extended to cover user-space locks.)

	Ingo

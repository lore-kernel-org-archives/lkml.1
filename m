Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbZDBCRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbZDBCRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZDBCQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:16:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbZDBCQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:16:49 -0400
Date: Thu, 2 Apr 2009 04:13:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090402021325.GB26446@elte.hu>
References: <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401201236.GK8014@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401201236.GK8014@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> On Wed, Apr 01, 2009 at 12:39:46PM -0700, Linus Torvalds wrote:
>
> > The thing is, things like "read_mostly" or "access_rarely" may 
> > talk about how we access those individual variables, but you're 
> > missing a _huge_ chunk of the puzzle if you ignore the 
> > _correlations_ of those accesses with accesses to other 
> > variables.
> > 
> > The thign is, if you have variables 'a' and 'b', and they are 
> > always accessed together, then it's probably worth it to put 
> > them in the same cacheline.
> 
> If you've got two global variables that are generally accessed 
> together, they should probably be `annotated' as such by putting 
> them in a struct.

It is certainly done so in a number of cases (say the RCU core and 
the scheduler), but i dont think it should be forced or preferred in 
any way.

IMHO it's equally good and clean code to have the global variables 
separately at the top of a .c file. Sometimes it's cleaner.

	Ingo

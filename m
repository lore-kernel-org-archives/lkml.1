Return-Path: <linux-kernel-owner+w=401wt.eu-S1762649AbYECKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649AbYECKKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYECKKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:10:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbYECKKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:10:30 -0400
Date: Sat, 3 May 2008 12:10:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
Message-ID: <20080503101016.GA18801@elte.hu>
References: <20080502.144827.158329188.davem@davemloft.net> <1209766054.6929.29.camel@lappy> <20080503082849.GA29605@elte.hu> <20080503.020502.226847930.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503.020502.226847930.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> > there's already such a mechanism in sched-devel.git (and has been 
> > there for a week or two): an architecture can set time_sync_thresh 
> > to -1LL during early bootup and essentially disable all the 
> > synchronization logic.
> 
> Does it remove all of the code too? :-)
> 
> Please give us a config boolean.  The only platform for which a 
> run-time knob is even necessary is x86.

yeah, will try something like that too.

the thing is, core kernel folks have to resist such pressures 
_somewhat_.

Architecture maintainers will put pressure on us from two directions: if 
a particular generic feature only helps _another_ architecture, they 
find it a nuisance and want it to be gone as much as possible.

If a particular feature helps them, they want it supported and 
default-enabled as much as possible. In fact, complaints come if a 
generic-looking feature shows up in one architecture only. (recent 
example: inlining optimizations ;-)

And you are totally right about sched_clock() being dead on accurate an 
globally synchronous on sparc64 - and you are right to find _any_ issue 
about it a nuisance. I totally envy you that sparc64's sched_clock() is 
so simple - it should have been like that on x86 years ago, if hw 
designers werent so impotent about it.

( although please note that the growing generalization that goes on
  _did_ find a subtle nohz problem on sparc64 early in the merge window,
  so it's not like these changes are totally useless to you. )

but it all goes in the other direction as well: many folks find 
endianness problems a nuisance on x86, many folks find TLB and explicit 
cache coherence complications a nuisance on x86 as well. The bus-to-phys 
complication which is an identity on x86. Etc. etc.

But the core kernel is a conscious and intelligent union of all 
architecture's needs, and often we maintain complications even if they 
make no sense on the most popular platform. I think it makes strategic 
sense because it keep the kernel truly generic and truly clean. It also 
keeps architectures honest: even today the x86 architecture is still not 
as clean as sparc64 for example.

so please be patient, we are working on it :)

	Ingo

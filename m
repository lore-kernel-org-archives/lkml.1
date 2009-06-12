Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbZFLP47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbZFLP47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbZFLP4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:56:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54709 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZFLP4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:56:50 -0400
Date: Fri, 12 Jun 2009 17:56:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open
	when supported
Message-ID: <20090612155641.GB26644@elte.hu>
References: <20090612121757.GD31845@elte.hu> <8bd0f97a0906120522v51ae0151i48d5f6846ddcff10@mail.gmail.com> <20090612123152.GE31845@elte.hu> <8bd0f97a0906120541x739b7902pe40ff7aa91337bac@mail.gmail.com> <20090612125941.GI31845@elte.hu> <8bd0f97a0906120604o1e90ac93l469e86173224364e@mail.gmail.com> <20090612130949.GJ31845@elte.hu> <8bd0f97a0906120621o609d7489v83cd3efc0102412d@mail.gmail.com> <20090612135603.GF32105@elte.hu> <20090612162529.2fc4d863@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612162529.2fc4d863@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > On Fri, Jun 12, 2009 at 09:09, Ingo Molnar wrote:
> > > > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > > >> On Fri, Jun 12, 2009 at 08:59, Ingo Molnar wrote:
> > > >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > > >> >> On Fri, Jun 12, 2009 at 08:31, Ingo Molnar wrote:
> > > >> >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > > >> >> >> On Fri, Jun 12, 2009 at 08:17, Ingo Molnar wrote:
> > > >> >> >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > > >> >> >> >> On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
> > > >> >> >> >> > * Mike Frysinger <vapier@gentoo.org> wrote:
> >
> 
> > Anyway, i have no time to teach you about kernel mainteinance basics 
> > really so i probably wont follow up on future emails.
> 
> So yet again you resort to personal attacks when someone objects to the
> world according to Ingo. [...]

You snipped out the proper context. The thing i object to above was 
a technically completely unacceptable solution proposed by Mike:

|  #ifndef __NR_perf_counter_open
|  # error sorry, your arch has not hooked up perf_counter_open syscall yet
|  #endif
|
| is completely unacceptable. We dont propagate build failures via 
| user-enable config options, we never did. There's a lot of people 
| doing randconfig builds - if it randomly failed due to your 'fix' 
| that would upset a lot of testing for no good reason.

and that opinion still holds. (If you disagree then go try to push 
such a solution upstream, and please share with me the various 
replies you will get, it will be an entertaining read.)

Mike made valid technical points later on though and i replied to 
them and accepted most of them. We can certainly annotate out that 
warning message from scripts/checksyscalls.sh.

	Ingo

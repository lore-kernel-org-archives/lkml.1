Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYAHWgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYAHWgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYAHWgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:36:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYAHWgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:36:16 -0500
Date: Tue, 8 Jan 2008 23:35:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rik van Riel <riel@redhat.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in
	arch/x86/ia32/ia32_aout.c
Message-ID: <20080108223554.GE21482@elte.hu>
References: <20080108203233.01bb5c7f@paolo-desktop> <20080108150439.6388028e@bree.surriel.com> <20080108215247.GE14829@elte.hu> <20080108221722.GA27698@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108221722.GA27698@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > Most of these kernel changes would probably get in the way of real 
> > > development, making patches reject that would otherwise apply.
> > 
> > I'm curious, in what way would they interfere?
> 
> Developer A work one some complicated stuff in foo.c which is not yet 
> -mm fooder.
> 
> Developer B submits and have applied a massive cleanup to some of the 
> files touced by Developer A's patch.
> 
> Developer A now needs to fix up his stuff.

Solution: Developer A does a trivial patch -R for the changes that 
generate rejects. Cleanups are NOPs and they are almost infinitely 
splittable. You can apply and unapply them chunk by chunk, almost 
always.

and we actually have first-hand experience with the effects of 
largescale cleanups:

> > How many times did we have to do this in x86.git? Once or twice - 
> > out of 100+ cleanup patches.

i've never seen cleanups truly interfere with development work, in fact 
i mostly saw the positive effects of them. They are easily undone and 
easily redone. But they do keep developers honest (no lame "oh, i'll 
clean this up after i do feature X, Y and Z") and they do keep newbies 
involved. The Linux kernel does have a fundamental "we are too hostile 
towards newbies" problem. It's also fundamentally Linuxish: nobody 
really "owns" the code in an exclusive fashion. If you dont keep it 
clean, someone else will clean it up for you.

and even if there are patch conflicts, it can all be done intelligently 
and trivially. Mail us: "please do not clean up pgtable.h because i'm 
working on unifying it and will do the cleanup after that" and we dont 
clean it up.

But broad statements of "cleanups hinder development work" are just 
plain _WRONG_. Cleanups are good by default - full stop. There are 
exceptions, and we all recognize them when we see them.

> > Firstly, anyone with a forked kernel with outstanding patches that 
> > are not in x86.git only has themselves to blame. We want to actively 
> > discourage forking and sitting on patches too long.
> 
> Curious - what is the purpose of the x86.git tree these days?

what do want to imply by 'these days'?

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZGALvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZGALvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGALvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:51:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47683 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZGALvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:51:08 -0400
Date: Wed, 1 Jul 2009 13:49:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/6 -tip] perf_counter: Add Generalized Hardware
	vectored co-processor support for AMD
Message-ID: <20090701114928.GI15958@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam> <1246440909.3403.5.camel@hpdv5.satnam> <1246440977.3403.7.camel@hpdv5.satnam> <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu> <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246448441.6940.3.camel@hpdv5.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Wed, 2009-07-01 at 13:27 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > >  Performance counter stats for '/usr/bin/vlc /home/jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv':
> > > > 
> > > >     20177177044  vec-adds                  (scaled from 66.63%)
> > > >     34101687027  vec-muls                  (scaled from 66.64%)
> > > >      3984060862  vec-divs                  (scaled from 66.71%)
> > > >     26349684710  vec-idle-cycles           (scaled from 66.65%)
> > > >      9052001905  vec-stall-cycles          (scaled from 66.66%)
> > > >     76440734242  vec-ops                   (scaled from 66.71%)
> > > > 
> > > >   272.523058097  seconds time elapsed
> > 
> > btw., the 'perf list' bits are missing - any new counter added 
> > should be listed by 'perf list' as well - otherwise people wont know 
> > what we have and what to use.
> > 
> 
> Even cache is not available for 'perf list'. Should I also resend 
> patch for adding cache along with vector and interrupt.

I'd suggest for you to send a separate patch for the cache bits 
first (that way it's not held up by other dependencies) - and keep 
the vector and irq bits in their respective patches.

I.e. when we add new generic events, we want to enable it in the 
full tool-space in a single patch.

	Ingo

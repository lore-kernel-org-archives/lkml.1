Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXLHPma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXLHPma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbXLHPmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:42:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54866 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXLHPmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:42:20 -0500
Date: Sat, 8 Dec 2007 16:41:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Mark Lord <lkml@rtr.ca>, Guillaume Chazarain <guichaz@yahoo.fr>,
       stefano.brivio@polimi.it, Nick Piggin <nickpiggin@yahoo.com.au>,
       Robert Love <rml@tech9.net>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071208154122.GE30270@elte.hu>
References: <20071207084559.GA11162@elte.hu> <200712081627.45937.mb@bu3sch.de> <20071208153327.GC30270@elte.hu> <200712081636.45828.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712081636.45828.mb@bu3sch.de>
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


* Michael Buesch <mb@bu3sch.de> wrote:

> > i cannot see how. You can verify msleep by running something like this:
> > 
> >   while :; do time usleep 111000; done
> > 
> > you should see a steady stream of:
> > 
> >  real    0m0.113s
> >  real    0m0.113s
> >  real    0m0.113s
> > 
> > (on an idle system). If it fluctuates, with occasional longer delays, 
> > there's some timer problem present.
> 
> Does the sleeping and timing use different time references?

yes. But the real paranoid can do this from another box:

  while :; do time ssh testbox usleep 111000; done

	Ingo

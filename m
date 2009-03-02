Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbZCBX6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbZCBX6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZCBX6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:58:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45526 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZCBX6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:58:37 -0500
Date: Tue, 3 Mar 2009 00:58:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090302235817.GC19084@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021520.30826.david-b@pacbell.net> <20090302232650.GA14515@elte.hu> <200903021548.19504.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903021548.19504.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> On Monday 02 March 2009, Ingo Molnar wrote:
> > 
> > > > > What's unfortunate is that you prefer not to fix that
> > > > > IRQF_DISABLED bug in lockdep, which you co-"maintain".
> > > > > When running with lockdep, that bug (a) introduces bugs
> > > > > in some drivers and (b) hides bugs in others.  You've
> > > > > rejected even a minimal warning fix, to help minimize
> > > > > the amount of time developers waste on (a) and (b).
> > > > 
> > > > I've come to the conclusion that the only technically sound solution is
> > > > to do as I proposed today, utterly eliminate !IRQF_DISABLED handlers.
> > > 
> > > As you announced today.  If you truly believe that, then
> > > you should at least submit a warning patch for 2.6.29-rc
> > > ("driver X isn't setting IRQF_DISABLED, reimplement!")
> > 
> > i have changed the BUG_ON() to a WARN_ONCE() message so the 
> > warning is in place now.
> 
> The patch Peter sent doesn't relate in the least to removing 
> the IRQF_DISABLED flag though.  Patches addressing that would 
> be in setup_irq() code paths not IRQ dispatch.

yes, i referred to the BUG_ON(!irq_irq()) patch.

	Ingo

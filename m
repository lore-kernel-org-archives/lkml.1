Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbXGYIwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbXGYIwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXGYIwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:52:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54722 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXGYIwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:52:15 -0400
Date: Wed, 25 Jul 2007 10:52:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070725085204.GA22067@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070725014912.35c7e325.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725014912.35c7e325.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > apparently the functionality of the soft lockup watchdog was never 
> > actually tested with that patch applied ...
> > 
> > [this is -stable material too.]
> 
> Still isn't working.  I'm getting random meaningless softlockup 
> trippings coming out for no apparent reason.

hm, you still havent applied the other 4 patches i sent:

 softlockup-fix.patch

 softlockup-add-irq-regs-h.patch
 softlockup-better-printout.patch
 softlockup-cleanups.patch
 softlockup-use-cpu-clock.patch

they are all necessary.

softlockup-use-cpu-clock.patch could easily solve the present problem 
you have: as i pointed it out it is _wrong_ to use sched_clock(), 
because sched_clock() is not a reliable clocksource. Especially on your 
VAIO.

	Ingo

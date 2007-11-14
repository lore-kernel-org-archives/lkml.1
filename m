Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXKNJ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXKNJ7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXKNJ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:59:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47876 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbXKNJ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:59:45 -0500
Date: Wed, 14 Nov 2007 10:59:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-ID: <20071114095930.GA21325@elte.hu>
References: <200711091136.20051.david-b@pacbell.net> <200711121726.39263.david-b@pacbell.net> <20071113093414.GA5270@elte.hu> <200711131122.45950.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711131122.45950.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Brownell <david-b@pacbell.net> wrote:

> > 	 Why do you want to use raw_spinlock_t?
> 
> Already answered elsewhere in this thread ... I'll highlight the point 
> that such bitops shouldn't be preemption points.

raw_spinlock_t is a spinlock-internal implementation detail in the 
upstream kernel. You should _not_ be using it. The PREEMPT_RT 
raw_spinlock_t markings will move upstream in the future together with 
that feature, not piecemail wise with other patches. In other words: 
raw_spinlock_t in PREEMPT_RT != raw_spinlock_t in the upstream kernel. 
(and dont be worried, any necessary raw_spinlock_t annotations _will_ 
move upstream together with PREEMPT_RT, once that feature is being 
merged, so your code is not missing out on anything.)

The only code that should use raw_spinlock_t in the upstream kernel is 
the spinlock code and occasionally some debugging code. (If you still 
see any other strong reasons for it then please state it in simple, 
standalone terms without depending on context - your reasons were not 
clear to me so far so either me or you are confused about something and 
this is probably just a matter of communication.)

	Ingo

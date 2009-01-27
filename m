Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZA0Pue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZA0Pue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZA0PuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:50:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZA0PuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:50:25 -0500
Date: Tue, 27 Jan 2009 16:49:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Message-ID: <20090127154946.GA28209@elte.hu>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901262148.49717.rjw@sisk.pl> <20090126213519.GB13670@elte.hu> <200901271628.54037.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901271628.54037.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > In fact whatever check you put in it's _always_ going to be 
> > fundamentally more fragile than direct instrumentation: you cannot 
> > possibly check all possible places that enable interrupts. (they could 
> > be disabling interrupts as a _restore_irqs() sequence for example)
> 
> In this particular case, I'm not really interested in that.  What I'm 
> interested in is which driver's ->suspend_late() or ->resume_early() (or 
> the equivalents for sysdevs) has enabled interrupts, which is quite easy 
> to check directly.

But this is exactly what it does - without any need for debug checks 
spread around!

You'll get a _full stack dump_ from the very driver that is enabling 
interrupts! You dont get a trace - you get a stack dump of the very place 
that is buggy. It does not get any better than that.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbXLDAFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbXLDAFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 19:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXLDAFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 19:05:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58399 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXLDAFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 19:05:45 -0500
Date: Tue, 4 Dec 2007 01:05:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
       penberg@cs.helsinki.fi, lkml@astralstorm.puszkin.org,
       arjan@infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071204000513.GB15296@elte.hu>
References: <20071202165913.3eaebee6@laptopd505.fenrus.org> <200712031928.53659.rjw@sisk.pl> <20071203192426.GA8017@elte.hu> <200712032347.37723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712032347.37723.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > Er, it won't play well if that happen when tasks are frozen for 
> > > suspend.
> > 
> > right now any suspend attempt times out after 20 seconds:
> > 
> >   $ grep TIMEOUT kernel/power/process.c
> >   #define TIMEOUT (20 * HZ)
> >           end_time = jiffies + TIMEOUT;
> 
> This is the timeout for freezing tasks, but if the freezing succeeds, 
> they can stay in TASK_UNINTERRUPTIBLE for quite some more time, 
> especially during a hibernation (the tasks stay frozen until we power 
> off the system after saving the image).

ah, ok. So this was a live bug - thanks for the clarification.

	Ingo

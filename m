Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYL3Hip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYL3Hip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYL3HiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:38:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYL3HiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:38:21 -0500
Date: Tue, 30 Dec 2008 08:38:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
Message-ID: <20081230073807.GA2455@elte.hu>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com> <20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com> <20081229162314.1cc7a549.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229162314.1cc7a549.akpm@linux-foundation.org>
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

* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +/*
> > + * Stop the automatic memory scanning thread. This function must be called
> > + * with the kmemleak_mutex held.
> > + */
> > +void stop_scan_thread(void)
> > +{
> > +	if (scan_thread) {
> > +		kthread_stop(scan_thread);
> > +		scan_thread = NULL;
> > +	}
> > +}
> 
> so... why do we need a kernel thread?
> 
> We could have (for the sake of argument) a sys_kmemleak_scan() which 
> does a single scan then returns.  Or something like that.  That way, 
> userspace directly gets to set the scanning frequency, thread priority, 
> etc.

thread priority of a kernel thread can be set anyway. Kernel threads tend 
to be better for such simple things because we can control all aspects, 
start them automatically so that test setups catch it (without needing any 
userspace component), etc.

	Ingo

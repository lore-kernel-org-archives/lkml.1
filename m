Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbXH0TXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbXH0TXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXH0TXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:23:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36644 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbXH0TXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:23:33 -0400
Date: Mon, 27 Aug 2007 21:23:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070827192324.GA29441@elte.hu>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu> <20070823121341.GA5775@elte.hu> <20070827191905.GE1894@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827191905.GE1894@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2355]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> > -	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task/2) {
> > +	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task) {
> 
> Ingo, this is still broken. This condition is always false for nice-0 
> tasks..

yes - negative reniced tasks are not spread out via this - and positive 
reniced tasks are spread out more easily.

	Ingo

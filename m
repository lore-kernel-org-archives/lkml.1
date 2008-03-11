Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYCKJ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYCKJ7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYCKJ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:59:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYCKJ7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:59:11 -0400
Date: Tue, 11 Mar 2008 10:59:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Message-ID: <20080311095900.GU25110@elte.hu>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <20080311075845.GA13758@elte.hu> <200803111928.20043.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803111928.20043.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1505]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Just a quick suggestion, does a simple runtime tune like this fix 
> > the workload:
> >
> >   for N in /proc/sys/kernel/sched_domain/*/*/flags; do
> >      echo $[`cat $N`|16] > N
> >   done
> >
> > this sets SD_WAKE_IDLE for all the nodes in the scheduler domains 
> > tree. (doing this results in over-agressive idle balancing - but if 
> > this fixes your testcase it shows that we were balancing 
> > under-agressively for this workload.) Thanks,
> 
> It doesn't change anything.
> 
> There is no idle time for this workload, btw.

oh, i thought you said that. Could you try to turn SD_WAKE_AFFINE 
all-off and all-on perhaps, via the same scriptlet?

	Ingo

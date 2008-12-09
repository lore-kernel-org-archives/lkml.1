Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbYLIGfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbYLIGfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 01:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYLIGfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 01:35:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51034 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYLIGfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 01:35:04 -0500
Date: Tue, 9 Dec 2008 07:34:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] idle_balance() does not call load_balance_newidle()
Message-ID: <20081209063448.GA17706@elte.hu>
References: <20081208152249.GI5457@dirshya.in.ibm.com> <20081208154939.GA405@elte.hu> <20081209040706.GA20525@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209040706.GA20525@dirshya.in.ibm.com>
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2008-12-08 16:49:39]:
> 
> > 
> > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > > Hi,
> > > 
> > > load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE is
> > > set at higher level domain (3-CPU) and not in low level domain (2-MC).
> > > 
> > > pulled_task is initialised to -1 and checked for non-zero which is
> > > always true if the lowest level sched_domain does not have
> > > SD_BALANCE_NEWIDLE flag set.
> > > 
> > > Trivial fix to initialise pulled_task to zero.
> > > Patch against 2.6.28-rc7
> > 
> > applied to tip/sched/core, thanks! (Not for v2.6.28 because this could 
> > affect performance.)
> 
> Thanks Ingo.  This patch does not change any functionality in v2.6.28 
> and hence will not affect performance.  The SD flags are not touched. I 
> found this bug while setting different SD flags at MC level and CPU 
> level in my power saving balance patches.

if it does not change any functionality then we would not be doing the 
change, right?

It does change functionality, because:

> > > load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE is 
> > > set at higher level domain (3-CPU) and not in low level domain 
> > > (2-MC).

even though it's a bug fix, it affects how the SD flags are interpreted 
and acted upon by the load balancer - i.e. the change can impact 
performance.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXFZO7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXFZO7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbXFZO7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:59:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978AbXFZO7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:59:17 -0400
Date: Tue, 26 Jun 2007 16:58:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070626145825.GA31076@elte.hu>
References: <20070625200601.GA18980@elte.hu> <46805C4F.1050200@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46805C4F.1050200@rtr.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Lord <lkml@rtr.ca> wrote:

> Ingo Molnar wrote:
> >Subject: [patch] sys_time() speedup
> >From: Ingo Molnar <mingo@elte.hu>
> >
> >improve performance of sys_time(). sys_time() returns time in seconds, 
> >but it does so by calling do_gettimeofday() and then returning the 
> >tv_sec portion of the GTOD time. But the data structure "xtime", which 
> >is updated by every timer/scheduler tick, already offers HZ granularity 
> >time.
> 
> How well synchronized is xtime with real-time ?

it's updated by every jiffy.

> Programs invoking sys_time() do expect it to be as accurate as 
> gettimeofday(), even if only at 1-second boundaries.

yes.

	Ingo

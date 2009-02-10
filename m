Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZBJNOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZBJNOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZBJNOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:14:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60677 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZBJNOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:14:36 -0500
Date: Tue, 10 Feb 2009 14:14:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perf_counter: Make software counters work as per-cpu
	counters
Message-ID: <20090210131428.GA11571@elte.hu>
References: <18832.5815.706605.434454@cargo.ozlabs.ibm.com> <20090209114852.GF18757@elte.hu> <1234232518.2604.335.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234232518.2604.335.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> > > Signed-off-by: Paul Mackerras <paulus@samba.org>
> I tested it. The patch does fix the crash.

Great!

> > ok - i've applied your patch from email to allow Yanmin to test tip:master.
> Ingo,
> 
> Here is the patch to add system-wide collection for perfstat.c.
> 
> With the new parameter '-s', perfstat introduces very little overhead to benchmark 
> testing. [...]

Very nice. I've applied your patch to perfstat.c and have uploaded the new version 
to the usual place:

   http://redhat.com/~mingo/perfcounters/perfstat.c

> [...] If tracking performance data without '-s', sometimes perfstat has too much 
> impact on benchmark results, especially on netperf UDP-U-4k.

Yes - and we need to optimize that. It wont ever be zero-cost though, so -s makes 
sense independently of any need for optimizations. -s can also be used to measure 
the overhead of perfstat per task counters itself, via recursive inherited counters 
like this:

   perfstat -s perfstat ./workload

Thanks,

	Ingo

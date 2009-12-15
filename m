Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbZLOTJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbZLOTJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbZLOTJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:09:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbZLOTJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:09:15 -0500
Date: Tue, 15 Dec 2009 20:08:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 1/2] perf_event: Fix incorrect range check on cpu number
Message-ID: <20091215190858.GA15443@elte.hu>
References: <20091215084032.GA18661@brick.ozlabs.ibm.com>
 <1260873092.4165.354.camel@twins>
 <20091215110055.GC18661@brick.ozlabs.ibm.com>
 <4B27DB70.50304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27DB70.50304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> 
> Paul Mackerras wrote:
> >On Tue, Dec 15, 2009 at 11:31:32AM +0100, Peter Zijlstra wrote:
> >
> >>On Tue, 2009-12-15 at 19:40 +1100, Paul Mackerras wrote:
> >>>It is quite legitimate for CPUs to be numbered sparsely, meaning that
> >>>it possible for an online CPU to have a number which is greater than
> >>>the total count of possible CPUs.
> >>>
> >>>Currently find_get_context() has a sanity check on the cpu number
> >>>where it checks it against num_possible_cpus().  This test can fail
> >>>for a legitimate cpu number if the cpu_possible_mask is sparsely
> >>>populated.
> >>>
> >>>This fixes the problem by checking the CPU number against
> >>>nr_cpumask_bits instead, since that is the appropriate check to ensure
> >>>that the cpu number is same to pass to cpu_isset() subsequently.
> >>Cute, do you actually have hardware that does this?
> >
> >Yeah, Mikey ran across this on a POWER7 box here.
> 
> Does the perf tool need to be fixed too?  The "perf stat" tool, at
> least, has a "-a" switch that tells the tool to count the event on
> all cpus, and it does this by iterating over the number of cpus,
> 0..n, assuming they are all contiguous.

Yes, see patch 2/2 of this series.

	Ingo

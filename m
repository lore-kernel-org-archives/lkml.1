Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZIHMg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZIHMg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZIHMg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:36:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbZIHMg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:36:26 -0400
Date: Tue, 8 Sep 2009 14:36:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       jens.axboe@oracle.com
Subject: Re: [PATCH 0/2]: Get perf counters working on D-cache aliasing
	cpus.
Message-ID: <20090908123610.GA3515@elte.hu>
References: <20090908.051045.26522683.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908.051045.26522683.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> With Jen's Axboe's basic sparc counter patch in my tree I started 
> playing with it on sparc64.  Turns out it won't work on anything 
> pre-Niagara.
> 
> The issue is D-cache aliasing between the kernel side mapping and 
> the user side mapping of the perf event ring buffer.
> 
> The following two patches attempt to address this issue and are 
> working properly on my test machine.

Oh, great!

The only (small) worry would be that this uses vmalloc space on 
32-bit platforms which is generally a scarce resource.

IMHO it's not a big issue as the typical workflow would be to have 
just a handful of perf ring-buffers around and most of the 
performance work happens in the 64-bit space anyway.

One practical complication is lots of tracepoints and perf trace: 
but we can solve that via output buffer multiplexing: 
PERF_COUNTER_IOC_SET_OUTPUT - which is implemented in 
tip:perfcounters/core but not yet propagated to the tools. That 
would be desirable to do anyway, to enable time-coherent trace 
entries, etc.

	Ingo

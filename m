Return-Path: <linux-kernel-owner+w=401wt.eu-S1764500AbYDOQtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764500AbYDOQtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYDOQtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:49:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYDOQtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:49:03 -0400
Date: Tue, 15 Apr 2008 18:48:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415164814.GA15842@elte.hu>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415134705.GB22351@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Now for some performance impact :

absent from your figures is dyn-ftrace :-)

dyn-ftrace is a young but rather nifty tool that extends on old-style 
static tracepoints rather forcefully, by adding 75,000+ tracepoints to 
the kernel here and now, with no in-source maintainence overhead at all. 
(It's a nice add-on to SystemTap because it adds space for a jprobe, but 
i digress ;-)

anyway, my objections against markers would be reduced quite 
significantly, if we were able to improve the immediate values 
optimization to not actually patch the MOV's constant portion, but to 
just patch both the MOV and the branch instruction, into two NOPs.

in fact, we can do even better: we should turn the immediate values 
optimization into a simple "patch out a jump to the slowpath" 
optimization. I.e. just a single instruction to patch in and out. (and 
that makes the NMI impact all that easier to handle as well)

That would pretty much meet my "the typical trace point should have the 
cost of a single NOP" threshold for fastpath tracing overhead, which 
i've been repeating for 2 years now, and which would make the scheduler 
markers a lot more palatable ;-)

hm?

	Ingo

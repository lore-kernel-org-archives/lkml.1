Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYKMJks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYKMJks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYKMJkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:40:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYKMJkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:40:39 -0500
Date: Thu, 13 Nov 2008 10:40:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
	return tracer lockless
Message-ID: <20081113094027.GK25479@elte.hu>
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu> <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com> <20081113085551.GF25479@elte.hu> <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com> <20081113092340.GJ25479@elte.hu> <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> If so that would be suitable. And for his purpose, the ring-buffer 
> would propose a function for time snapshot adapted to the current 
> flags and that rely on sched_clock?

yeah - and it would be all means by a global entity in the beginning - 
i.e. we'd just generalize the code around ring_buffer_time_stamp() to 
listen to the "globally coherent" flag, and allow it to be used for 
callgraph cost measurement code too.

If the "globally coherent" flag is set, then the implementation would 
be something like:

A simple "last global timestamp" value combined with a "last local 
timestamp" value, and the global timestamp is only ever moved forward. 
It is updated via cmpxchg loop. This gives coherency and a monotonic 
clock. The local timestamp would be taken from cpu_clock(cpu), and a 
global timestamp would be constructed out of it. Or something like 
that.

Would that work? [ Would you be interested in sending patches? :-) ]

	Ingo

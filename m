Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbXFDORn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbXFDORn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXFDORg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:17:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbXFDORf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:17:35 -0400
Date: Mon, 4 Jun 2007 16:17:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       James Carter <jwcart2@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [bug] very high non-preempt latency in
	context_struct_compute_av()
Message-ID: <20070604141718.GA29674@elte.hu>
References: <20070604112745.GA26350@elte.hu> <Line.LNX.4.64.0706040924040.11109@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706040924040.11109@d.namei>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> > the latency is caused by a _very_ long loop in the SELinux code:
> > 
> >     sshd-4828  0.N.. 465894us : avtab_search_node (context_struct_compute_av)
> 
> What do the 0DNs fields mean and what did you use to create this 
> trace?

i used the latency tracer from -rt. Here's the meaning of the fields:

                  _------=> CPU#
                 / _-----=> irqs-off
                | / _----=> need-resched 
                || / _---=> hardirq/softirq
                ||| / _--=> preempt-depth
                |||| /
                |||||     delay
    cmd     pid ||||| time  |   caller
       \   /    |||||   \   |   /
 trace-it-4751  0D...    0us : __next_cpu (user_trace_start)

it's very easy to interpret: it traces all the function calls the kernel 
executes, and puts the symbolic function name (and its parent function) 
into the trace, time ordered. So it's a proper execution trace. Normally 
you can ignore the 'DN' type of flags - what matters in this case is the 
observed 130 msecs latency and the functions that were called while that 
latency happened.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYKRNwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYKRNwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYKRNwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:52:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbYKRNw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:52:29 -0500
Date: Tue, 18 Nov 2008 14:52:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
Message-ID: <20081118135221.GE31146@elte.hu>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > Hence the trace buffer will be empty. The patch below makes the 
> > selftests working for me, since then they run in preemptible 
> > context. But it is ugly and I'm not proposing it for upstream ;)
> > 
> > Just wanted to make you aware that there is a bug.
> 
> Yep, this might be a better answer than what I put into linux-tip 
> (and my git repo).
> 
> See:
> 
>   ftrace: force pass of preemptoff selftest
> 
> The cause of the bug was the conversion of the BKL back to a 
> spinlock, and making it non preempt.  The initcall code is called 
> with the BKL applied which now means it can not preempt. This breaks 
> the preempt tracer selftest.
> 
> My solution was to just force a pass if this is detected. Perhaps 
> moving the test might be better.

it would be better to just drop the BKL in that selftest. (or in all 
selftests - an elevated preempt count will skew a number of things)

	Ingo

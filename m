Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYKDII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYKDII1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYKDIIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:08:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYKDIIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:08:18 -0500
Date: Tue, 4 Nov 2008 09:07:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: function tracer with irqs disabled
Message-ID: <20081104080747.GA27075@elte.hu>
References: <20081104041554.605521183@goodmis.org> <20081104042203.499871423@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104042203.499871423@goodmis.org>
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

> Running hackbench 3 times with the irqs disabled and 3 times with 
> the preempt disabled function tracer yielded:
> 
> tracing type       times            entries recorded
> ------------      --------          ----------------
> irq disabled      43.393            166433066
>                   43.282            166172618
>                   43.298            166256704
> 
> preempt disabled  38.969            159871710
>                   38.943            159972935
>                   39.325            161056510

your numbers might be correct, but i found that hackbench is not 
reliable boot-to-boot - it can easily produce 10% systematic noise or 
more. (perhaps depending on how the various socket data structures 
happen to be allocated)

the really conclusive way to test this would be to add a hack that 
either does preempt disable or irqs disable, depending on a runtime 
flag - and then observe how hackbench performance reacts to the value 
of that flag.

note that preempt-disable will also produce less trace entries, 
especially in very irq-rich workloads. Hence it will be "faster".

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbYKPGWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbYKPGWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPGWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:22:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43141 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYKPGWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:22:22 -0500
Date: Sun, 16 Nov 2008 07:22:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/branch-tracer: Fix a trace recursion on
	branch tracer
Message-ID: <20081116062213.GA32215@elte.hu>
References: <491FA8C8.1040905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FA8C8.1040905@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: Make the branch tracer use raw irq save/restore
> 
> When the branch tracer inserts an event through 
> probe_likely_condition(), it calls local_irq_save() and then results 
> in a trace recursion.
> 
> local_irq_save() -> trace_hardirqs_off() -> trace_hardirqs_off_caller()
> 	-> unlikely()
> 
> The trace_branch.c file is protected by DISABLE_BRANCH_PROFILING but 
> that doesn't prevent from external call to functions that use 
> unlikely().
> 
> My box crashed each time I tried to set this tracer (sudden and hard 
> reboot).

So this patch fixes that problem, or are there other problems left?

	Ingo

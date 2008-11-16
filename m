Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbYKPGuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbYKPGuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYKPGty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:49:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43093 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYKPGtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:49:53 -0500
Date: Sun, 16 Nov 2008 07:49:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/branch-tracer: Fix a trace recursion on
	branch tracer
Message-ID: <20081116064948.GD32215@elte.hu>
References: <491FA8C8.1040905@gmail.com> <20081116062213.GA32215@elte.hu> <c62985530811152232q2794ce1o6732c241821c6eca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811152232q2794ce1o6732c241821c6eca@mail.gmail.com>
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

> 2008/11/16 Ingo Molnar <mingo@elte.hu>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> Impact: Make the branch tracer use raw irq save/restore
> >>
> >> When the branch tracer inserts an event through
> >> probe_likely_condition(), it calls local_irq_save() and then results
> >> in a trace recursion.
> >>
> >> local_irq_save() -> trace_hardirqs_off() -> trace_hardirqs_off_caller()
> >>       -> unlikely()
> >>
> >> The trace_branch.c file is protected by DISABLE_BRANCH_PROFILING but
> >> that doesn't prevent from external call to functions that use
> >> unlikely().
> >>
> >> My box crashed each time I tried to set this tracer (sudden and hard
> >> reboot).
> >
> > So this patch fixes that problem, or are there other problems left?
> >
> >        Ingo
> >
> 
> 
> I forgot to answer to all. Yes that fixes it.

cool - i was seeing the crashes too in automated testing, just havent 
had time to debug it yet.

One small detail:

Regarding the "Impact" line, it's cool that you started adding them. 
I'd like to ask you to tweak them a little bit in the future: please 
try to describe the "practical impact" via them - not just a 
repetition of the source code change that the patch does.

For example, for this patch, instead of this impact-line:

  Impact: Make the branch tracer use raw irq save/restore

a better one is:

  Impact: fix crash when enabling the branch-tracer

(i changed it in this patch, no need to resubmit. And it's not well 
documented anyway.)

Thanks,

	Ingo

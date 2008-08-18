Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYHRHCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYHRHCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYHRHB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:01:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYHRHB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:01:59 -0400
Date: Mon, 18 Aug 2008 09:01:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: a.p.zijlstra@chello.nl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scale sysctl_sched_shares_ratelimit with nr_cpus
Message-ID: <20080818070147.GA4801@elte.hu>
References: <37E52D09333DE2469A03574C88DBF40F024EBD2F@pdsmsx414.ccr.corp.intel.com> <20080818065220.GA2711@elte.hu> <37E52D09333DE2469A03574C88DBF40F024EBD69@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37E52D09333DE2469A03574C88DBF40F024EBD69@pdsmsx414.ccr.corp.intel.com>
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


* Zhang, Yanmin <yanmin.zhang@intel.com> wrote:

> >>cool. It's already upstream (post-rc3 commit):
> [YM] But comparing with 2.6.26, volanoMark result still has about 60%
> regression.

Does a scheduler trace show anything about why that drop happens? Do 
something like this to trace the scheduler:

assuming debugfs is mounted under /debug and CONFIG_SCHED_TRACER=y:

  echo 1 > /debug/tracing/tracing_cpumask
  echo sched_switch > /debug/tracing/available_tracers
  cat /debug/tracing/trace_pipe > trace.txt

( regarding tracing_cpumask: trace only 1 CPU to make sure volanomark is 
  not disturbed too much by many-CPUs tracing. )

	Ingo

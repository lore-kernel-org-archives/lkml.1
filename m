Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZCMNIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZCMNIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbZCMNHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:07:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44886 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759034AbZCMNHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:07:49 -0400
Date: Fri, 13 Mar 2009 14:07:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] generic software counters -v2
Message-ID: <20090313130730.GA10117@elte.hu>
References: <20090313112125.886730125@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313112125.886730125@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> This patch set improves the current software counters by 
> providing sampling events for most of them.
> 
> The clock based software counters use hrtimers to generate 
> events, allowing sample based profiling without hardware 
> support -- obviously this has limited functionality for kernal 
> based profiling since we disable interrupts quite frequently, 
> but should be good for userspace.
> 
> Other events like pagefaults insert simple hooks into the 
> actual pagefault code to generate these events.

Very nice series! Applied to tip:core/locking and 
tip:perfcounters/core - thanks Peter!

Fixed a trivial !PERF_COUNTERS build failure as well.

> Future work (in-progress) will hook into the tracepoint 
> infrastructure to to provide profiling events.

Cool!

Especially for pagefaults we have a number of callbacks there: 
kmmio, kprobes, kmemcheck, tracing, perfcounters - they could 
indeed all be consolidated step by step onto a tracepoint.

	Ingo

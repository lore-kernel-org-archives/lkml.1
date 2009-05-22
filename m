Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbZEVTSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbZEVTSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZEVTSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:18:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39734 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195AbZEVTSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:18:20 -0400
Date: Fri, 22 May 2009 21:18:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: dynamically allocate tasks'
	perf_counter_context struct
Message-ID: <20090522191813.GA18651@elte.hu>
References: <18963.63352.489273.92145@cargo.ozlabs.ibm.com> <20090520171207.GA16706@elte.hu> <18964.36622.94267.309523@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18964.36622.94267.309523@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Paul Mackerras <paulus@samba.org> wrote:
> > 
> > > This replaces the struct perf_counter_context in the task_struct 
> > > with a pointer to a dynamically allocated perf_counter_context 
> > > struct.  The main reason for doing is this is to allow us to 
> > > transfer a perf_counter_context from one task to another when we 
> > > do lazy PMU switching in a later patch.
> > 
> > Hm, i'm not sure how far this gets us towards lazy PMU switching.
> > 
> > In fact i'd say that the term "lazy PMU switching" is probably 
> > misleading, we should use: "equivalent PMU context switching" or 
> > instead.
> 
> Yes, that's what I mean.
> 
> As you say, we need to be able to detect when two tasks have 
> equivalent contexts - that is, when their counters are all 
> inherited from a common ancestor.  My idea is that in that 
> situation we simply swap the contexts: move the context of the 
> outgoing task onto the incoming task, and give the incoming task's 
> context to the outgoing task.  With my patch, that involves simply 
> swapping the pointers over and adjusting the task pointers in the 
> two contexts.
> 
> That means that all the counters get transferred over to the 
> incoming task, so there is nothing in the PMU or the arch code 
> that needs to changed or adjusted.  The outgoing task still has a 
> perfectly valid context, so it doesn't matter if it migrates to 
> another CPU.  The nice thing is that there is nothing special or 
> unusual about the state after we have swapped the contexts - 
> nothing that needs to be remembered or undone later.

Yeah, agreed - your scheme is simpler than the scheme i thought of!

	Ingo

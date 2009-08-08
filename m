Return-Path: <linux-kernel-owner+w=401wt.eu-S934055AbZHHMEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055AbZHHMEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZHHMEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:04:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbZHHMEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:04:32 -0400
Date: Sat, 8 Aug 2009 14:03:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Message-ID: <20090808120315.GA14086@elte.hu>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com> <1249633282.32113.613.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com> <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com> <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu> <1249667341.17467.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249667341.17467.5.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-08-07 at 13:33 +0200, Ingo Molnar wrote:
> >  Peter, any ideas?
> 
> 
> > [  995.556131] ------------[ cut here ]------------
> > [  995.557128] WARNING: at kernel/perf_counter.c:1191 __perf_counter_task_sched_out+0x48/0x6b()
> 
> 
> Some yeah...

This patch fixed both the warning i was getting during stress-tests, 
and it also solved the hard lockup i was getting with the latest BTS 
patch.

( perf record never actually finishes even short workloads, due to
  the flood of kernel events coming in faster than it can record, so
  we grow and grow the perf.data - but that's a different matter, it
  does not lock up anymore. )

Markus, does latest -tip work fine for you, is the lockup fixed on 
your side as well?

	Ingo

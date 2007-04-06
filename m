Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbXDFTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbXDFTXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXDFTXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:23:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXDFTXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:23:15 -0400
Date: Fri, 6 Apr 2007 21:22:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: [patch] sched: get rid of p->children use in show_task()
Message-ID: <20070406192259.GA18722@elte.hu>
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070406191806.GA15291@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406191806.GA15291@elte.hu>
User-Agent: Mutt/1.4.2.2i
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > i.e. a to-be-reaped task will still be on the main list _too_. The 
> > > main list is for all the PID semantics rules. The reap-list is 
> > > just for wait4() processing. The two would be completely separate.
> > 
> > And what pray tell except for heuristics is the list of children 
> > used for?
> 
> yeah - by all means get rid of it, but first separate the data 
> structures along uses. Then all the 'why should we iterate two lists 
> in sequence' questions vanish.

and this way we get the best change as well: not only will kthreads be 
removed from that list, but all other tasks in the system too. I bet 
this will speed up wait4() _enormously_, on server workloads that 
involve many tasks.

	Ingo

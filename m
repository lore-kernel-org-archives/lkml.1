Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXDDOPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXDDOPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXDDOPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:15:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbXDDOPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:15:54 -0400
Date: Wed, 4 Apr 2007 16:15:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [sched] redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
Message-ID: <20070404141546.GA862@elte.hu>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Hello,
> 
> Scenario:
> 
> Currently running [task1] boosts a priority (lowers a static_prio) of 
> [task2] via { setpriority -> set_user_nice } and [task2] happens to be 
> in the "expired" array at the moment.
> 
> According to the set_user_nice(), "delta" is negative (the prio is 
> boosted) and, hence, resched_task(rq->curr) is called.
> 
> As the [task2] is in the "expired" array and there are still tasks (at 
> least [task1]) in the "active" one, the triggered reschedule is just 
> useless (e.g. gets control back to [task1]).
> 
> Am I missing something?
> 
> The same is applicable to rt_mutex_setprio().
> 
> Of course, not a big deal, but it's easily avoidable, e.g. (delta < 0 
> && array == rq->active).

i think you are right and a micro-optimization could be done here. Would 
you like to do a patch for this?

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZJ0NEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZJ0NEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZJ0NEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:04:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58891 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZJ0NEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:04:13 -0400
Date: Tue, 27 Oct 2009 14:04:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu: allow pcpu_alloc() to be called with IRQs
	off
Message-ID: <20091027130407.GB32628@elte.hu>
References: <alpine.LSU.2.00.0910271328340.19847@wotan.suse.de> <4AE6EDBF.7040905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE6EDBF.7040905@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Tejun Heo <tj@kernel.org> wrote:

> Jiri Kosina wrote:
> > pcpu_alloc() and pcpu_extend_area_map() perform a series of
> > spin_lock_irq()/spin_unlock_irq() calls, which make them unsafe
> > with respect to being called from contexts which have IRQs off.
> > 
> > This patch converts the code to perform save/restore of flags instead,
> > making pcpu_alloc() (or __alloc_percpu() respectively) to be called
> > from early kernel startup stage, where IRQs are off.
> > 
> > This is needed for proper initialization of per-cpu rq_weight data from
> > sched_init().
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> I'll wait for response on the series and push it through percpu#fixes 
> tomorrow if there's no objection.

Yep, the 2/2 sched.c patch looks good now:

  Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo

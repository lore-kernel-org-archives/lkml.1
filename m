Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYIJLu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYIJLu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYIJLuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:50:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45442 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYIJLuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:50:50 -0400
Date: Wed, 10 Sep 2008 13:50:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080910115036.GA29560@elte.hu>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910114755.GA9696@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> but i think it should be a single primitive sprinkled around, 
> might_fault(), which would be something like:
> 
> > > +	might_sleep();
> > > +	if (current->mm)
> > > +		might_lock_read(&current->mm->mmap_sem);
> 
> that way it's a lot less visually intrusive as well.

in any case i've applied the current patches to tip/core/locking:

 c10d38d: x86: some lock annotations for user copy paths
 76b189e: lockdep: add might_lock() / might_lock_read()

to see the fallout. The cleanup can be done after that.

( Nick, i've added your Acked-by to 76b189e - let me know if you dont 
  want that. )

	Ingo

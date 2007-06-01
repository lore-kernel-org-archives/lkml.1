Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbXFATV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbXFATV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762885AbXFATVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:21:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762477AbXFATVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:21:48 -0400
Date: Fri, 1 Jun 2007 21:21:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Yu <raise.sail@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070601192142.GA10039@elte.hu>
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu> <465E992C.4020601@gmail.com> <20070531095337.GA8104@elte.hu> <465FC7E7.7080804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465FC7E7.7080804@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Li Yu <raise.sail@gmail.com> wrote:

> Also, I have want to know what's real meaning of
> 
>    add_wait_runtime(rq, curr, delta_mine - delta_exec);
> 
> in update_curr(), IMHO, it should be
> 
>    add_wait_runtime(rq, curr, delta_mine - delta_fair);
> 
> Is this just another heuristics? or my opinion is wrong again? :-)

well, ->wait_runtime is in real time units. If a task executes 
delta_exec time on the CPU, we deduct "-delta_exec" 1:1. But during that 
time the task also got entitled to a bit more CPU time, that is 
+delta_mine. The calculation above expresses this. I'm not sure what 
sense '-delta_fair' would make - "delta_fair" is the amount of time a 
nice-0 task would be entitled to - but this task might not be a nice-0 
task. Furthermore, even for a nice-0 task why deduct -delta_fair - it 
spent delta_exec on the CPU.

	Ingo

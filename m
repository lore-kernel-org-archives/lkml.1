Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbXFFHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbXFFHDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbXFFHDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:03:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbXFFHDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:03:10 -0400
Date: Wed, 6 Jun 2007 09:01:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS scheduler, -v15
Message-ID: <20070606070143.GA7375@elte.hu>
References: <20070531150908.GA23538@elte.hu> <20070606064228.GA22443@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606064228.GA22443@in.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> > i'm pleased to announce release -v15 of the CFS scheduler patchset.
> 
> Do I smell a bug when a task switches its scheduling classes?
> 
> Lets say a task was in real-time class for a long time and switches to 
> fair-sched class. When update_curr() is called on this new fair-sched 
> task, some of required fields (for ex: exec_start) are uninitialized 
> and can lead to bogus calculations?

yep, you are right. Dmitry Adamushko and Balbir Singh are working on 
this area, and my tree already contains the fixes for rt task's 
exec_start. (this also gives us the ability to have precise 'top' 
statistics for RT tasks.) So this should be fixed in -v16. (Since it's 
quite uncommon for a task to drop in and out of scheduling classes, this 
problem was found via review, not via any user-visible regression.)

> Also, real-time tasks are currently influencing fair clock 
> calculations (because there is only one raw_weighted_load field per 
> runqueue). Is that intentional?

yep - the 'fair clock' in essence freezes when RT tasks are running (but 
not completely). Can you think of any bad effect from this perhaps? It's 
useful to have unified load-balancing (smpnice-driven) between the RT 
and fair classes.

	Ingo

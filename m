Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbXKSNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbXKSNMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXKSNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:12:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34072 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbXKSNMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:12:13 -0500
Date: Mon, 19 Nov 2007 14:12:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 2/2] sched: Improve fairness of cpu allocation for task
	groups
Message-ID: <20071119131201.GB31491@elte.hu>
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119123051.GC28777@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> The current load balancing scheme isn't good for group fairness.

> ---
>  include/linux/sched.h |    4 
>  kernel/sched.c        |  292 +++++++++++++++++++++++++++++++++++++++++++++-----
>  kernel/sched_fair.c   |   95 ++++++++++------
>  kernel/sched_rt.c     |    2 
>  kernel/sysctl.c       |   16 ++
>  5 files changed, 348 insertions(+), 61 deletions(-)

i'm leaning towards making this v2.6.25 material, as it affects the 
non-group-scheduling bits too and is rather large. When i tested it, 
group scheduling worked pretty well - at least for CPU bound tasks - and 
on SMP too. Could we live with what we have for now and defer this patch 
to v2.6.25? If not, could you split up this patch in a way to defer all 
the FAIR_GROUP_SCHED relevant changes to a separate patch which will not 
affect the !FAIR_GROUP_SCHED case at all? That will make the case much 
clearer.

	Ingo

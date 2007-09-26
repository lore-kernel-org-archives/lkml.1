Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbXIZLWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbXIZLWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXIZLVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:21:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbXIZLVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:21:51 -0400
Date: Wed, 26 Sep 2007 13:21:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926112137.GA13876@elte.hu>
References: <20070926085202.GE3337@deprecation.cyrius.com> <1190802208.7318.5.camel@Homer.simpson.net> <20070926104814.GM3337@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926104814.GM3337@deprecation.cyrius.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Martin Michlmayr <tbm@cyrius.com> wrote:

> * Mike Galbraith <efault@gmx.de> [2007-09-26 12:23]:
> > I noticed on the iperf website a patch which contains sched_yield().
> > http://dast.nlanr.net/Projects/Iperf2.0/patch-iperf-linux-2.6.21.txt
> > 
> > Do you have that patch applied by any chance?  If so, it might be a
> > worth while to try it without it.
> 
> Yes, this patch was applied.  When I revert it, I get the same (high) 
> performance with both kernels.

great! Could you try this too:

   echo 1 > /proc/sys/kernel/sched_compat_yield

does it fix iperf performance too (with the yield patch applied to 
iperf)?

I think the real fix would be for iperf to use blocking network IO 
though, or maybe to use a POSIX mutex or POSIX semaphores.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbXFNUnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbXFNUnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXFNUnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:43:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbXFNUnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:43:00 -0400
Date: Thu, 14 Jun 2007 22:42:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vassili Karpov <av1474@comtv.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: accurate user accounting
Message-ID: <20070614204253.GA14076@elte.hu>
References: <200703251159.03616.kernel@kolivas.org> <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org> <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru> <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru>
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


* Vassili Karpov <av1474@comtv.ru> wrote:

> Hello Ingo and others,
> 
> After reading http://lwn.net/Articles/236485/ and noticing few 
> refernces to accounting i decided to give CFS a try. With 
> sched-cfs-v2.6.21.4-16 i get pretty weird results, it seems like 
> scheduler is dead set on trying to move the processes to different 
> CPUs/cores all the time. And with hog (manually tweaking the amount 
> iterations) i get fairly strange resuls, first of all the process is 
> split between two cores, secondly while integral load provided by the 
> kernel looks correct, it's off by good 20 percent on each idividial 
> core.
> 
> (http://www.boblycat.org/~malc/apc/hog-cfs-v16.png)
> 
> Thought this information might be of some interest.

hm - what does 'hog' do, can i download hog.c from somewhere?

the alternating balancing might be due to an uneven number of tasks 
perhaps? If you have 3 tasks on 2 cores then there's no other solution 
to achieve even performance of each task but to rotate them amongst the 
cores.

> P.S. How come the /proc/stat information is much closer to reality 
>      now? Something like what Con Kolivas suggested was added to 
>      sched.c?

well, precise/finegrained accounting patches have been available for 
years, the thing with CFS is that there we get them 'for free', because 
CFS needs those metrics for its own logic. That's why this information 
is much closer to reality now. But note: right now what is affected by 
the changes in the CFS patches is /proc/PID/stat (i.e. the per-task 
information that 'top' and 'ps' displays, _not_ /proc/stat) - but more 
accurate /proc/stat could certainly come later on too.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbXFRGoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbXFRGoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXFRGn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:43:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbXFRGn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:43:57 -0400
Date: Mon, 18 Jun 2007 08:43:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618064343.GA31113@elte.hu>
References: <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu>
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


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > could you try the quick hack below, ontop of cfs-v17? It adds two 
> > things to wait_task_inactive():
> > 
> > - a cond_resched() [in case you are running !PREEMPT]
> > 
> > - use MONITOR+MWAIT to monitor memory transactions to the rq->curr
> >   cacheline. This should make the polling loop definitely fair.
> 
> Is it not possible for the mwait to get stuck?

it is - when the other CPU does nothing.

> > If this solves the problem on your box then i'll do a proper fix and 
> > introduce a cpu_relax_memory_change(*addr) type of API to around 
> > monitor/mwait. This patch boots fine on my T60 - but i never saw 
> > your problem.
> 
> Yes, the patch does make the pauses go away.  In fact just the 
> smp_mb() seems to suffice.

cool! Could you send me the smallest patch you tried that still made the 
hangs go away?

	Ingo

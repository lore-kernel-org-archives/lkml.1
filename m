Return-Path: <linux-kernel-owner+w=401wt.eu-S935615AbXGQSJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935615AbXGQSJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbXGQSJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:09:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60360 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbXGQSJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:09:23 -0400
Date: Tue, 17 Jul 2007 20:09:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717180916.GD7905@elte.hu>
References: <20070716215117.GA25097@elte.hu> <20070716.150902.55721400.davem@davemloft.net> <20070716223718.GA494@elte.hu> <20070716.155753.34760312.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716.155753.34760312.davem@davemloft.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 17 Jul 2007 00:37:18 +0200
> 
> > I think if you leaned back and thought it through, and if you 
> > applied this scenario to a bad scheduler commit from me that broke 
> > your box, you'd readily agree with me =B-) (which scenario is purely 
> > hypothetical, my scheduler commits are all 100% perfect of course 
> > ;-)
> 
> Actually I'd probably send you a patch for any bug I found that 
> triggered on sparc64, since that's faster than asking you to fix a bug 
> that you are unlikely to be able to trigger on your own systems.
> 
> But that's just how I operate.
> 
> Ask Thomas Gleixner.  Every single hrtimers/nohz bug I've found on 
> sparc64, I sent him either a full fix or a full analysis of the bug 
> and a description of exactly what is going on and what needs to be 
> changed so he can compose the bug fix patch with minimal effort.

yeah, i too usually try to fix bugs straight away - just check:

   git-log net drivers/net | grep "Author: Ingo Molnar"

but in this current case i was freshly back from a few days off, had 
quite a backlog after a rather complex set of merges and i just didnt 
have the time.

And i really applaud you for the clockevents/dynticks contributions (i 
loved your dynticks patches and the clockevents framework fixes that 
resulted out of it), but i really, really think this case is apples to 
oranges. I had some urgent hacking to do in some completely different 
area (not networking) and i ran across that networking regression and 
spent more than an hour on bisecting it.

The bad commit looked simple so i thought the person who is doing it 
(Olaf) would immediately see the bug (i certainly didnt see it). It's 
also not that easy to debug that box, the only remote debugging 
interface to it is ... netconsole. If i were into networking changes 
right now i'd probably have tried to debug and fix it straight away.

So instead i opted to bisect it, to give you the exact bad commit, give 
you full logs of the incident and an offer to run arbitrary patches 
immediately.

There's also little loss from the revert AFAICS: the commit went into 
your tree on July 11th and went upstream July 12th and i found it on 
July 16th. So (unless the commit dates are deceiving me) it does not 
seem to be an over-tested patch with lots of QA value (yet), and it's 
not some critical commit that another 100 commits grew to depend on. 
It's nevertheless a fix we want to have, and i'm willing to test 
anything.

	Ingo

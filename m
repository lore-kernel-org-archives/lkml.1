Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXGEIoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXGEIoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbXGEInl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:43:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49546 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbXGEInj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:43:39 -0400
Date: Thu, 5 Jul 2007 10:43:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070705084323.GB2447@elte.hu>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4> <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg> <20070703173112.GA108@tv-sign.ru> <1183549772.3812.10.camel@johannes.berg> <20070704125219.GA98@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704125219.GA98@tv-sign.ru>
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


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > > Isn't it better to call lock_release() with nested == 1 ?
> > 
> > Not sure, Ingo?
> 
> Ingo, could you also explain the meaning of "nested" parameter? Looks 
> like it is just unneeded, lock_release_nested() does a quick check and 
> use lock_release_non_nested() when hlock is not on top of stack.

hm, i forgot about that. We basically turned off all bad-nesting 
warnings in lockdep due to false positives.

the workqueue dependencies should all nest perfectly so please just use 
nested==1, even though it's a dummy right now. We might want to turn 
unlock-nest checking back on in the future. Or we'll remove that 
parameter altogether.

	Ingo

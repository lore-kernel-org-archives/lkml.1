Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXGCTmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXGCTmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbXGCTmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:42:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51256 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbXGCTmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:42:46 -0400
Date: Tue, 3 Jul 2007 21:42:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070703194229.GB493@elte.hu>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4> <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg> <20070703173112.GA108@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703173112.GA108@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Now we have a false positive if some time we queue B into that 
> workqueue, and this is not good.
> 
> We can avoid this problem if we put lockdep_map into work_struct, so 
> that wait_on_work() "locks" work->lockdep_map, while flush_workqueue() 
> takes wq->lockdep_map.
> 
> But probably we don't need this right now, at least until we really 
> have a lot of false positives while converting from flush_workqueue() 
> to cancel_work_sync/cancel_delayed_work_sync.

would be nice to map the real dependencies. Adding another lockdep_map 
is really low-cost and the lack of false positives is reassuring.

	Ingo

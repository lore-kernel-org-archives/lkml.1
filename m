Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbXGEOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbXGEOlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbXGEOlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:41:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40529 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbXGEOk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:40:59 -0400
Date: Thu, 5 Jul 2007 16:40:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] workqueue: debug flushing deadlocks with lockdep
Message-ID: <20070705144047.GA9548@elte.hu>
References: <20070705110744.564273000@sipsolutions.net> <20070705110820.304578000@sipsolutions.net> <20070705143217.GA170@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705143217.GA170@tv-sign.ru>
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

> Currently it is allowed that work->func() does flush_workqueue() on 
> its own workqueue. So we have
> 
> 	run_workqueue()
> 		work->func()
> 			flush_workqueue()
> 				run_workqueue()
> 
> All but work->func() take wq->lockdep_map, I guess check_deadlock() 
> won't be happy.

yep.

> OTOH. Perhaps we can can forbid such a behaviour? Andrew, do you know 
> any good example of "keventd trying to flush its own queue" ?

i'd prefer to make the API a little bit stricter: such recursion is 
nasty. Btw., what mechanism prevents the second instance of 
run_workqueue() calling into a work->func() again?

	Ingo

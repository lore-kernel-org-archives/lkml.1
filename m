Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXGEIqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXGEIqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXGEIpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:45:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbXGEIpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:45:52 -0400
Date: Thu, 5 Jul 2007 10:45:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
Message-ID: <20070705084538.GA3476@elte.hu>
References: <1183583529.9662.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183583529.9662.34.camel@johannes.berg>
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> +#ifdef CONFIG_LOCKDEP
> +		/*
> +		 * It is permissible to free the struct work_struct
> +		 * from inside the function that is called from it,
> +		 * this we need to take into account for lockdep too.
> +		 * To avoid bogus "held lock freed" warnings as well
> +		 * as problems when looking into work->lockdep_map,
> +		 * make a copy and use that here.
> +		 */
> +		struct lockdep_map lockdep_map = work->lockdep_map;
> +#endif

> +		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
>  		f(work);
> +		lock_release(&lockdep_map, 1, _THIS_IP_);

neat trick :)

	Ingo

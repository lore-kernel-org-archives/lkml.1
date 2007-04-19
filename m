Return-Path: <linux-kernel-owner+w=401wt.eu-S1030859AbXDSGOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030859AbXDSGOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030864AbXDSGOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:14:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030859AbXDSGOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:14:22 -0400
Date: Thu, 19 Apr 2007 08:14:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] workqueue: debug possible lockups in flush_workqueue
Message-ID: <20070419061416.GB18894@elte.hu>
References: <20070419055247.GA1782@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419055247.GA1782@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> Here is my patch proposal for detecting possible lockups, when 
> flush_workqueue caller holds a lock (e.g. rtnl_lock) also used in work 
> functions.

looks good in principle - did you test it and it caught a bug that wasnt 
caught before?

> +#ifdef CONFIG_PROVE_LOCKING
> +/* Detect possible flush_workqueue() lockup with circular dependency check. */
> +static struct lockdep_map flush_dep_map = { .name = "flush_dep_map" };
> +#endif

> +#ifdef CONFIG_PROVE_LOCKING
> +		/* lockdep dependency: flush_dep_map (read) before any lock: */
> +		lock_acquire(&flush_dep_map, 0, 0, 1, 2, _THIS_IP_);
> +#endif

i think the #ifdef should only be needed for the .name initialization - 
both lock_acquire() and lock_release() maps to NOP if PROVE_LOCKING is 
off.

	Ingo

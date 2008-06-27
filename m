Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYF0MKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYF0MKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbYF0MEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:04:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbYF0MEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:04:05 -0400
Date: Fri, 27 Jun 2008 14:03:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
Message-ID: <20080627120350.GB30872@elte.hu>
References: <20080627000445.346130358@saeurebad.de> <20080627000805.504878592@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627000805.504878592@saeurebad.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0569]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> Wake up the watchdog every second instead of every second. [...]

now _that_ is a real improvement ;-)

>  	/* Wake up the high-prio watchdog task every second: */
> -	if (now > (touch_timestamp + 1))
> +	if (now > touch_timestamp)
>  		wake_up_process(per_cpu(watchdog_task, this_cpu));

you mean wake up every second instead of every two seconds?

i think the best sleep period for the watchdog is half of the threshold. 
It makes no point to check sooner than that. I.e. softlockup_thresh/2 
would be better?

	Ingo

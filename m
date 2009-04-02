Return-Path: <linux-kernel-owner+w=401wt.eu-S1764502AbZDBSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764502AbZDBSKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZDBSKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:10:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37481 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486AbZDBSKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:10:44 -0400
Date: Thu, 2 Apr 2009 20:10:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] RFC perf_counter: singleshot support
Message-ID: <20090402181026.GA6340@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.257773792@chello.nl> <1238674691.8530.5948.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238674691.8530.5948.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> OK, so I just remembered the sigio thing mentioned by Paul a while 
> back.
> 
> and this should do I suppose...

> @@ -1561,6 +1578,7 @@ void perf_counter_wakeup(struct perf_cou
>  	rcu_read_unlock();
>  
>  	wake_up_all(&counter->waitq);
> +	kill_fasync(&counter->fasync, SIGIO, POLL_IN);

ah, yes.

Do we even need the explicit signo method this way? The SIGIO target 
is configurable via fcntl(F_SETSIG), right?

	Ingo

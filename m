Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbZEONgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbZEONgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZEONgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:36:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZEONgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:36:08 -0400
Date: Fri, 15 May 2009 15:35:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/4] perf_counter: frequency based adaptive irq_period
Message-ID: <20090515133547.GA9285@elte.hu>
References: <20090515131925.616419905@chello.nl> <20090515132018.646195868@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515132018.646195868@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> @@ -2907,6 +2940,12 @@ perf_counter_alloc(struct perf_counter_h
>  
>  	pmu = NULL;
>  
> +	hwc = &counter->hw;
> +	if (hw_event->freq && hw_event->irq_freq)
> +		hwc->irq_period = TICK_NSEC / hw_event->irq_freq;

this needs to use a 64-bit do_div method too, otherwise we get this 
on 32-bit:

 kernel/built-in.o: In function `perf_counter_alloc':
 perf_counter.c:(.text+0x7ddc7): undefined reference to `__udivdi3'

	Ingo

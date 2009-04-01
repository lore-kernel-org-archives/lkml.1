Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbZDAJkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbZDAJkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZDAJj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:39:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZDAJj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:39:58 -0400
Date: Wed, 1 Apr 2009 11:39:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 09/15] perf_counter tools: optionally scale counter
	values in perfstat mode
Message-ID: <20090401093942.GB27865@elte.hu>
References: <20090330170701.856843742@chello.nl> <20090330171023.871484899@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330171023.871484899@chello.nl>
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

> From: Paul Mackerras <paulus@samba.org>
> 
> Impact: new functionality
> 
> This adds add an option to the perfstat mode of kerneltop to scale 
> the reported counter values according to the fraction of time that 
> each counter gets to count.  This is invoked with the -l option (I 
> used 'l' because s, c, a and e were all taken already.)  This uses 
> the new PERF_RECORD_TOTAL_TIME_{ENABLED,RUNNING} read format 
> options.
> 
> With this, we get output like this:
> 
> $ ./perfstat -l -e 0:0,0:1,0:2,0:3,0:4,0:5 ./spin
> 
>  Performance counter stats for './spin':
> 
>      4016072055  CPU cycles           (events)  (scaled from 66.53%)
>      2005887318  instructions         (events)  (scaled from 66.53%)
>         1762849  cache references     (events)  (scaled from 66.69%)
>          165229  cache misses         (events)  (scaled from 66.85%)
>      1001298009  branches             (events)  (scaled from 66.78%)
>           41566  branch misses        (events)  (scaled from 66.61%)
> 
>  Wall-clock time elapsed:  2438.227446 msecs
> 
> This also lets us detect when a counter is zero because the 
> counter never got to go on the CPU at all.  In that case we print 
> <not counted> rather than 0.

Nice! Shouldnt this be the default mode of output?

I think we want to make users aware of the fact when output is 
sampled due to over-commit, rather than precise, agreed?

	Ingo

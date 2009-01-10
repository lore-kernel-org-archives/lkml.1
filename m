Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZAJWnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZAJWnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZAJWnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:43:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbZAJWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:43:46 -0500
Date: Sat, 10 Jan 2009 23:43:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] irq: change irq_desc and kstat_irq_legacy to
	variable sized arrays
Message-ID: <20090110224323.GA17917@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110223818.459493000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> 
> The following patches change irq_desc and kstat_irq_legacy into
> variable sized arrays based on nr_cpu_ids when CONFIG_SPARSE_IRQS=y.
> 
>     irq: change references from NR_IRQS to nr_irqs
>     irq: allocate irq_desc_ptrs array based on nr_irqs
>     irq: initialize nr_irqs based on nr_cpu_ids
>     kstat: modify kstat_irqs_legacy to be variable sized
> 
> Based on: tip/cpus4096 @ v2.6.28-6140-g36c401a
> 
> (Ingo - I will push these to your tip/cpus4096 branch via my cpus4096-for-ingo
> 	git tree.)

Thanks - please send a pull request when you feel good about them.

The changes look good to me.

> Affects of the SPARSE changes on NR_CPUS values.
> 
>     1 - 128-defconfig (non-SPARSE)
>     2 - 4k-defconfig (non-SPARSE)
>     3 - 4k-defconfig (SPARSE)
> 
> ====== Data
> 
>       .1.        .2.        .3.    ..final..
>   1114112          .   -1114112      .  -100%  irq_desc(.data.cacheline_aligned)
>    208896     -69632    -138752    512   -99%  irq_cfgx(.data)
>     34816          .     -34816      .  -100%  irq_timer_state(.bss)
>     17480          .     -17480      .  -100%  per_cpu__kstat(.data.percpu)
>         0          .      +4096   4096      .  irq_desc_legacy(.data.cacheline_aligned)

Impressive!

If i remember your previous figures correctly we've got about +4MB of 
memory bloat at 4K CPUs, that is now down to 3MB total?

	Ingo

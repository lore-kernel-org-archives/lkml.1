Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZLAJhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZLAJhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZLAJhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:37:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:44389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZLAJhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:37:07 -0500
Subject: Re: [PATCH] perf_event: initialize data.period in
 perf_swevent_hrtimer()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B14E220.2050107@cn.fujitsu.com>
References: <4B14E220.2050107@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 10:37:05 +0100
Message-ID: <1259660225.26472.594.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 17:30 +0800, Xiao Guangrong wrote:
> In current code in perf_swevent_hrtimer(), data.period is not initialized,

Ah, very nice catch.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 0b9ca2d..040ee51 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4010,6 +4010,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
>  	event->pmu->read(event);
>  
>  	data.addr = 0;
> +	data.period = event->hw.last_period;
>  	regs = get_irq_regs();
>  	/*
>  	 * In case we exclude kernel IPs or are somehow not in interrupt



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbXCYIkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbXCYIkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXCYIkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:40:40 -0400
Received: from mail29.syd.optusnet.com.au ([211.29.132.171]:59043 "EHLO
	mail29.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbXCYIki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:40:38 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] sched: accurate user accounting
Date: Sun, 25 Mar 2007 18:39:23 +1000
User-Agent: KMail/1.9.5
Cc: linux list <linux-kernel@vger.kernel.org>, malc <av1474@comtv.ru>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200703251159.03616.kernel@kolivas.org> <20070325075134.GA14453@elte.hu>
In-Reply-To: <20070325075134.GA14453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703251839.24148.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007 17:51, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
>
> we want to do this - and we should do this to the vanilla scheduler
> first and check the results. I've back-merged the patch to before RSDL
> and have tested it - find the patch below. Vale, could you try this
> patch against a 2.6.21-rc4-ish kernel and re-test your testcase?

Great. That should fix a lot of misconceptions about cpu usage and HZ.

However-

> +/*
> + * Some helpers for converting nanosecond timing to jiffy resolution
> + */
> +#define NS_TO_JIFFIES(TIME)   ((TIME) / (1000000000 / HZ))
> +#define JIFFIES_TO_NS(TIME)   ((TIME) * (1000000000 / HZ))
> +

This hunk is already in mainline so it will be double defined now.

Thanks.

-- 
-ck

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbXGBQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbXGBQkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 12:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXGBQkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 12:40:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:40384 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbXGBQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 12:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iMucJnyckCKNB2SM1X6FpKDp6XAQUqqlgWrtbjL9C8FOl04IDm/emLLbzq0YAvZnG9id3CXTdNmFomD1gA/f/8makJj4w93Mrz/qpX2dUMdH0INYxEnCOcCyh6tqhuSNGYwFeh8tqlxGfvY9MU+7mfoYBpslKoEBGRqKX35xRU8=
Message-ID: <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
Date: Mon, 2 Jul 2007 18:40:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070702155029.GA13241@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
	 <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
	 <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
	 <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
	 <20070702155029.GA13241@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Ingo Molnar <mingo@elte.hu> wrote:
> thx. As an initial matter, could you double-check whether your v18
> kernel source has the patch below applied already?
>
>         Ingo
>
> Index: linux/kernel/sched_fair.c
> ===================================================================
> --- linux.orig/kernel/sched_fair.c
> +++ linux/kernel/sched_fair.c
> @@ -342,8 +342,9 @@ update_stats_enqueue(struct cfs_rq *cfs_
>                 s64 tmp;
>
>                 if (se->wait_runtime < 0) {
> -                       tmp = (0 - se->wait_runtime) << NICE_0_SHIFT;
> -                       key += (tmp * se->load.inv_weight) >> WMULT_SHIFT;
> +                       tmp = -se->wait_runtime;
> +                       key += (tmp * se->load.inv_weight) >>
> +                                       (WMULT_SHIFT - NICE_0_SHIFT);
>                 } else {
>                         tmp = se->wait_runtime * se->load.weight;
>                         key -= tmp >> NICE_0_SHIFT;
>
>

It does.

Vegard

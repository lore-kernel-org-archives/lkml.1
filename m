Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704Ab0AQHQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0AQHQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 02:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890Ab0AQHQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 02:16:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0AQHQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 02:16:40 -0500
Date: Sun, 17 Jan 2010 08:12:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roel Kluin <roel.kluin@gmail.com>, Cliff Wickman <cpw@sgi.com>,
       Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: bau_msg_head points to a_queue_first in
 uv_table_bases_finish()
Message-ID: <20100117071227.GC19512@elte.hu>
References: <4B507093.6050002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B507093.6050002@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roel Kluin <roel.kluin@gmail.com> wrote:

> bau_msg_head should point to bau_msg_head
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this correct?
> 
> diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
> index 364d015..3d66331 100644
> --- a/arch/x86/kernel/tlb_uv.c
> +++ b/arch/x86/kernel/tlb_uv.c
> @@ -691,7 +691,7 @@ uv_table_bases_finish(int blade,
>  			continue;
>  
>  		bcp = (struct bau_control *)&per_cpu(bau_control, cpu);
> -		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
> +		bcp->bau_msg_head	= bau_tablesp->bau_msg_head;
>  		bcp->va_queue_first	= bau_tablesp->va_queue_first;
>  		bcp->va_queue_last	= bau_tablesp->va_queue_last;
>  		bcp->msg_statuses	= bau_tablesp->msg_statuses;

Seems like you either caught a real bug - or that there's a somewhat quirky 
initialization sequence here which should be commented upon in the source.

Cliff, Robin, what's your take on Roel's patch?

Thanks,

	Ingo

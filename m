Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYCQT1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYCQT1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYCQT1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:27:32 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9833 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbYCQT1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:27:32 -0400
Date: Mon, 17 Mar 2008 20:27:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [Patch (block.git) 1/2] Add irqsave to spinlocks in call function  single interrupt
Message-ID: <20080317192727.GK17940@kernel.dk>
References: <47DE9DA7.1090805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DE9DA7.1090805@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17 2008, Alan D. Brunelle wrote:
> 
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> ---
>  kernel/smp.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 852abd3..7232e1c 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -24,12 +24,13 @@ void __cpuinit generic_init_call_single_data(void)
>  void generic_smp_call_function_single_interrupt(void)
>  {
>  	struct call_single_queue *q;
> +	unsigned long flags;
>  	LIST_HEAD(list);
>  
>  	q = &__get_cpu_var(call_single_queue);
> -	spin_lock(&q->lock);
> +	spin_lock_irqsave(&q->lock, flags);
>  	list_replace_init(&q->list, &list);
> -	spin_unlock(&q->lock);
> +	spin_unlock_irqrestore(&q->lock, flags);
>  
>  	while (!list_empty(&list)) {
>  		struct call_single_data *data;

This is included in the later series.

-- 
Jens Axboe


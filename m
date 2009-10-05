Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbZJEI4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbZJEI4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbZJEI4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:56:33 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46555 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758198AbZJEI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:56:33 -0400
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161
	check_flags+0xbe/0x180()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200910050315.n953FCD9030264@www262.sakura.ne.jp>
References: <200910050315.n953FCD9030264@www262.sakura.ne.jp>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 05 Oct 2009 09:55:51 +0100
Message-Id: <1254732951.371.6.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Oct 2009 08:55:52.0784 (UTC) FILETIME=[A4A17D00:01CA4599]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 12:15 +0900, Tetsuo Handa wrote:
> [PATCH 2.6.32-rc3] kmemleak: Use GFP_ATOMIC for early_alloc().
> 
> We can't use GFP_KERNEL inside rcu_read_lock().
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  mm/kmemleak.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.32-rc3.orig/mm/kmemleak.c
> +++ linux-2.6.32-rc3/mm/kmemleak.c
> @@ -833,7 +833,7 @@ static void early_alloc(struct early_log
>  	 */
>  	rcu_read_lock();
>  	object = create_object((unsigned long)log->ptr, log->size,
> -			       log->min_count, GFP_KERNEL);
> +			       log->min_count, GFP_ATOMIC);
>  	spin_lock_irqsave(&object->lock, flags);
>  	for (i = 0; i < log->trace_len; i++)
>  		object->trace[i] = log->trace[i];

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.

-- 
Catalin


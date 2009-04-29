Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZD2N0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZD2N0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbZD2NZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:25:24 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1880 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754580AbZD2NZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:25:23 -0400
Message-ID: <49F854B6.9020700@myri.com>
Date: Wed, 29 Apr 2009 09:23:02 -0400
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rick.jones2@hp.com, brice@myri.com, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] sched: account system time properly
References: <49F078FA.6010507@myri.com> <20090428163004.46733752.akpm@linux-foundation.org> <49F7DF44.8090907@cosmosbay.com> <49F805C9.9070303@cosmosbay.com> <20090429100840.77359cae@skybase> <49F81BC3.2050805@cosmosbay.com> <20090429114801.09637e46@skybase> <20090429102409.GB2373@elte.hu> <49F84BC1.7080602@cosmosbay.com>
In-Reply-To: <49F84BC1.7080602@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> On mostly idle cpu, irqs were thus not accounted and top or mpstat could tell
> user/admin that cpu was 100 % idle, 0.00 % irq, 0.00 % softirq, while it was not.
> 
> Reported-by: Andrew Gallatin <gallatin@myri.com>
> Re-reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> Tested-by: Eric Dumazet <dada1@cosmosbay.com>
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index b902e58..26efa47 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4732,7 +4732,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
>  
>  	if (user_tick)
>  		account_user_time(p, one_jiffy, one_jiffy_scaled);
> -	else if (p != rq->idle)
> +	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
>  		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
>  				    one_jiffy_scaled);
>  	else
> 

I can confirm this fixes the issue for me.   Thank you, and I am
sorry if my git-bisect fumble-fingers caused too much wasted time.

Cheers,

Drew

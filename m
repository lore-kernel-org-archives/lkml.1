Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZG0LqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZG0LqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZG0LqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:46:18 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:53590 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZG0LqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:46:17 -0400
Date: Mon, 27 Jul 2009 13:45:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch RFC 13/37] s390: cio/crw: semaphore cleanup
Message-ID: <20090727134512.5105470b@skybase>
In-Reply-To: <20090726081554.946759738@linutronix.de>
References: <20090726081459.455111897@linutronix.de>
	<20090726081554.946759738@linutronix.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 08:18:10 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The usage of this "mutex" is non obvious and probably a completion in
> some places. Make it a semaphore.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  drivers/s390/cio/crw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-tip/drivers/s390/cio/crw.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/s390/cio/crw.c
> +++ linux-2.6-tip/drivers/s390/cio/crw.c
> @@ -137,7 +137,7 @@ void crw_handle_channel_report(void)
>   */
>  static int __init crw_init_semaphore(void)
>  {
> -	init_MUTEX_LOCKED(&crw_semaphore);
> +	semaphore_init_locked(&crw_semaphore);
>  	return 0;
>  }
>  pure_initcall(crw_init_semaphore);
> 
> 

The crw_semaphore is a real semaphore and the init_MUTEX_LOCKED is
indeed confusing. semaphore_init_locked is a more sensible name even if
the end result is in both cases just a sema_init(sem, 0). Anyway, fine
with me:

Acked-By: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYFJPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYFJPL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYFJPLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:11:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:39696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYFJPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:11:36 -0400
Date: Tue, 10 Jun 2008 07:22:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resend Removes PID_MAX_DEFAULT.
Message-ID: <20080610072214.56bd3506@infradead.org>
In-Reply-To: <b9df5fa10806100050j684db890wc48ef0596ee95719@mail.gmail.com>
References: <b9df5fa10806100050j684db890wc48ef0596ee95719@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 13:50:26 +0600
"Rakib Mullick" <rakib.mullick@gmail.com> wrote:

> This removes use of PID_MAX_DEFAULT. please reply.

Hi,

can I ask why?
can you explain what is wrong with the original? To me it's a bit weird
to move this from a central location to 2 other places....


> 
> Signed-off-by: Md. Rakib Hassan Mullick (rakib.mullick@gmail.com)
> ---
> diff -upr linux-2.6.25-vanilla/include/linux/threads.h
> linux-2.6.25/include/linux/threads.h
> --- linux-2.6.25-vanilla/include/linux/threads.h	2008-04-17
> 08:49:44.000000000 +0600
> +++ linux-2.6.25/include/linux/threads.h	2008-06-07
> 18:46:29.000000000 +0600 @@ -22,15 +22,10 @@
>  #define MIN_THREADS_LEFT_FOR_ROOT 4
> 
>  /*
> - * This controls the default maximum pid allocated to a process
> - */
> -#define PID_MAX_DEFAULT (CONFIG_BASE_SMALL ? 0x1000 : 0x8000)
> -
> -/*
>   * A maximum of 4 million PIDs should be enough for a while.
>   * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see futex.h.]
>   */
>  #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
> -	(sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
> +	(sizeof(long) > 4 ? 4 * 1024 * 1024 : (CONFIG_BASE_SMALL ?
> 0x1000 : 0x8000)))
> 
>  #endif
> diff -upr linux-2.6.25-vanilla/kernel/pid.c linux-2.6.25/kernel/pid.c
> --- linux-2.6.25-vanilla/kernel/pid.c	2008-04-17
> 08:49:44.000000000 +0600 +++ linux-2.6.25/kernel/pid.c
> 2008-06-07 18:46:25.000000000 +0600 @@ -42,7 +42,10 @@ static struct
> hlist_head *pid_hash; static int pidhash_shift;
>  struct pid init_struct_pid = INIT_STRUCT_PID;
> 
> -int pid_max = PID_MAX_DEFAULT;
> +/*
> + * This controls the default maximum pid allocated to a process
> + */
> +int pid_max = CONFIG_BASE_SMALL ? 0x1000 : 0x8000 ;
> 
>  #define RESERVED_PIDS		300
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

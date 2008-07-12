Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYGLQqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYGLQqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 12:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYGLQqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 12:46:32 -0400
Received: from [194.117.236.238] ([194.117.236.238]:35161 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYGLQqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 12:46:31 -0400
Date: Sat, 12 Jul 2008 19:45:20 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tom Zanussi <tzanussi@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [mmotm] smp.c: fix build error
Message-ID: <20080712194520.2d45ea67@linux360.ro>
In-Reply-To: <20080712200835.F6AC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080712200835.F6AC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 20:11:02 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Now, init_call_single_data() is static function.
> then redundant declaration cause build error as below.
> 
>      kernel/smp.c:36: error: static declaration of
> ‘init_call_single_data’ follows non-static declaration
> include/linux/smp.h:77: error: previous declaration of
> ‘init_call_single_data’ was here kernel/smp.c:47: warning:
> initialization from incompatible pointer type make[1]: ***
> [kernel/smp.o] error 1
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> 
> ---
>  include/linux/smp.h |    5 -----
>  1 file changed, 5 deletions(-)
> 
> Index: b/include/linux/smp.h
> ===================================================================
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -74,15 +74,10 @@ void __smp_call_function_single(int cpui
>  #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
>  void generic_smp_call_function_single_interrupt(void);
>  void generic_smp_call_function_interrupt(void);
> -void init_call_single_data(void);
>  void ipi_call_lock(void);
>  void ipi_call_unlock(void);
>  void ipi_call_lock_irq(void);
>  void ipi_call_unlock_irq(void);
> -#else
> -static inline void init_call_single_data(void)
> -{
> -}
>  #endif
>  
>  /*

Thanks. Though IIRC I had already removed these things. They must've
returned there while adding things to the patch stack.


	Eduard

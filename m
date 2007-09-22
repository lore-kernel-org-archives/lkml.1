Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXIVRgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXIVRgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXIVRf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:35:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27762 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbXIVRf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:35:57 -0400
Date: Sat, 22 Sep 2007 10:35:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/mutex.h: unclear reference to convention
Message-Id: <20070922103542.432560ce.randy.dunlap@oracle.com>
In-Reply-To: <664979.77080.qm@web52001.mail.re2.yahoo.com>
References: <664979.77080.qm@web52001.mail.re2.yahoo.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007 01:41:17 -0700 (PDT) Matti Linnanvuori wrote:

> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> 
> Reference to two different conventions is unnecessarily unclear unless you know them already and requires seeking and reading another file for understanding.


Could you hit the Return/Enter key about every 70-72 characters or so,
to break up those long lines?
Thanks.

> Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> ---
> 
> --- linux-2.6.23-rc7/include/linux/mutex.h    2007-09-22 11:09:42.223763000 +0300
> +++ linux-2.6.23/include/linux/mutex.h    2007-09-22 11:11:19.416761000 +0300
> @@ -132,9 +132,19 @@ extern int __must_check mutex_lock_inter
>  # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
>  #endif
>  
> -/*
> - * NOTE: mutex_trylock() follows the spin_trylock() convention,
> - *       not the down_trylock() convention!

Someone was trying to be helpful in include/linux/mutex.h.
The real doc for the function is in kernel/mutex.c (and pasted
below).

Another convention is that we put kernel-doc with the implementation
(i.e., in .c files) when possible, not with the function prototype.
Of course, for inline functions or macros in header files, that's
where the kernel-doc has to live.

so we don't need this patch.


> +/***
> + * mutex_trylock - try acquire the mutex, without waiting
> + * @lock: the mutex to be acquired
> + *
> + * Try to acquire the mutex atomically. Returns 1 if the mutex
> + * has been acquired successfully, and 0 on contention.
> + *
> + * NOTE: this function follows the spin_trylock() convention, so
> + * it is negated to the down_trylock() return values! Be careful
> + * about this when converting semaphore users to mutexes.
> + *
> + * This function must not be used in interrupt context. The
> + * mutex must be released by the same task that acquired it.
>   */
>  extern int fastcall mutex_trylock(struct mutex *lock);
>  extern void fastcall mutex_unlock(struct mutex *lock);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

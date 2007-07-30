Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbXG3E6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbXG3E6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbXG3E6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:58:16 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:48276 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbXG3E6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:58:15 -0400
Date: Mon, 30 Jul 2007 10:28:04 +0530
To: Daniel Walker <dwalker@mvista.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 6/9] spinlock/rt_lock random cleanups
Message-ID: <20070730045804.GA7124@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@mvista.com>, mingo@elte.hu,
	linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20070730024534.369897977@mvista.com> <20070730024720.357083990@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024720.357083990@mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: ankita@in.ibm.com (Ankita Garg)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 07:45:40PM -0700, Daniel Walker wrote:
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  include/linux/rt_lock.h  |    6 ++++--
>  include/linux/spinlock.h |    5 +++--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.22/include/linux/rt_lock.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/rt_lock.h
> +++ linux-2.6.22/include/linux/rt_lock.h
> @@ -128,12 +128,14 @@ struct semaphore name = \
>   */
>  #define DECLARE_MUTEX_LOCKED COMPAT_DECLARE_MUTEX_LOCKED
> 
> -extern void fastcall __sema_init(struct semaphore *sem, int val, char *name, char *file, int line);
> +extern void fastcall
> +__sema_init(struct semaphore *sem, int val, char *name, char *file, int line);
> 
>  #define rt_sema_init(sem, val) \
>  		__sema_init(sem, val, #sem, __FILE__, __LINE__)
> 
> -extern void fastcall __init_MUTEX(struct semaphore *sem, char *name, char *file, int line);
> +extern void fastcall
> +__init_MUTEX(struct semaphore *sem, char *name, char *file, int line);
>  #define rt_init_MUTEX(sem) \
>  		__init_MUTEX(sem, #sem, __FILE__, __LINE__)
> 
> Index: linux-2.6.22/include/linux/spinlock.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/spinlock.h
> +++ linux-2.6.22/include/linux/spinlock.h
> @@ -126,7 +126,7 @@ extern int __lockfunc generic__raw_read_
> 
>  #ifdef CONFIG_DEBUG_SPINLOCK
>   extern __lockfunc void _raw_spin_lock(raw_spinlock_t *lock);
> -#define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
> +# define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)

Any reason behind including a space here?

>   extern __lockfunc int _raw_spin_trylock(raw_spinlock_t *lock);
>   extern __lockfunc void _raw_spin_unlock(raw_spinlock_t *lock);
>   extern __lockfunc void _raw_read_lock(raw_rwlock_t *lock);
> @@ -325,7 +325,8 @@ do {							\
> 
>  # define _read_trylock(rwl)	rt_read_trylock(rwl)
>  # define _write_trylock(rwl)	rt_write_trylock(rwl)
> -#define _write_trylock_irqsave(rwl, flags)  rt_write_trylock_irqsave(rwl, flags)
> +# define _write_trylock_irqsave(rwl, flags) \
> +	rt_write_trylock_irqsave(rwl, flags)
> 
>  # define _read_lock(rwl)	rt_read_lock(rwl)
>  # define _write_lock(rwl)	rt_write_lock(rwl)
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYH3F2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYH3F2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYH3F2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:28:07 -0400
Received: from ns.suse.de ([195.135.220.2]:44147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYH3F2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:28:06 -0400
Date: Sat, 30 Aug 2008 07:28:01 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix ticket spin lock asm constraints
Message-ID: <20080830052801.GA16897@wotan.suse.de>
References: <48B7FFB3.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B7FFB3.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

All these ticket lock patches look pretty good to me. Thanks for going over
it so thoroughly.

On Fri, Aug 29, 2008 at 12:54:59PM +0100, Jan Beulich wrote:
> In addition to these changes I doubt the 'volatile' on all the ticket
> lock asm()-s are really necessary.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Nick Piggin <npiggin@suse.de>
> 
> ---
>  include/asm-x86/spinlock.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.27-rc5/include/asm-x86/spinlock.h	2008-08-21 14:37:34.000000000 +0200
> +++ 2.6.27-rc5-x86-spinlock-constraints/include/asm-x86/spinlock.h	2008-08-19 12:43:22.000000000 +0200
> @@ -101,7 +101,7 @@ static __always_inline int __ticket_spin
>  		     "1:"
>  		     "sete %b1\n\t"
>  		     "movzbl %b1,%0\n\t"
> -		     : "=&a" (tmp), "=Q" (new), "+m" (lock->slock)
> +		     : "=&a" (tmp), "=&Q" (new), "+m" (lock->slock)
>  		     :
>  		     : "memory", "cc");
>  
> @@ -146,7 +146,7 @@ static __always_inline void __ticket_spi
>  		     /* don't need lfence here, because loads are in-order */
>  		     "jmp 1b\n"
>  		     "2:"
> -		     : "+Q" (inc), "+m" (lock->slock), "=r" (tmp)
> +		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
>  		     :
>  		     : "memory", "cc");
>  }
> @@ -166,7 +166,7 @@ static __always_inline int __ticket_spin
>  		     "1:"
>  		     "sete %b1\n\t"
>  		     "movzbl %b1,%0\n\t"
> -		     : "=&a" (tmp), "=r" (new), "+m" (lock->slock)
> +		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
>  		     :
>  		     : "memory", "cc");
>  
> 
> 

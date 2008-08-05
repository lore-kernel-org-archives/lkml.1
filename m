Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYHECIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYHECIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYHECIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:08:01 -0400
Received: from mx1.suse.de ([195.135.220.2]:42455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYHECIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:08:00 -0400
Date: Tue, 5 Aug 2008 04:07:59 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix spin_is_contended()
Message-ID: <20080805020758.GB15075@wotan.suse.de>
References: <4897228E.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897228E.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 02:38:54PM +0100, Jan Beulich wrote:
> The masked difference is what needs to be compared against 1, rather
> than the difference of masked values (which can be negative).

Dang, thanks.

> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Nick Piggin <npiggin@suse.de>
> 
> ---
>  include/asm-x86/spinlock.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.27-rc1/include/asm-x86/spinlock.h	2008-07-31 17:08:34.000000000 +0200
> +++ 2.6.27-rc1-x86-spin-is-contended/include/asm-x86/spinlock.h	2008-08-04 11:09:33.000000000 +0200
> @@ -65,7 +65,7 @@ static inline int __ticket_spin_is_conte
>  {
>  	int tmp = ACCESS_ONCE(lock->slock);
>  
> -	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
> +	return (((tmp >> 8) - tmp) & 0xff) > 1;
>  }
>  
>  static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
> @@ -127,7 +127,7 @@ static inline int __ticket_spin_is_conte
>  {
>  	int tmp = ACCESS_ONCE(lock->slock);
>  
> -	return (((tmp >> 16) & 0xffff) - (tmp & 0xffff)) > 1;
> +	return (((tmp >> 16) - tmp) & 0xffff) > 1;
>  }
>  
>  static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
> 
> 

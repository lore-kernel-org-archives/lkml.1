Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbXJYV2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbXJYV2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXJYV2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:28:17 -0400
Received: from www.tglx.de ([62.245.132.106]:60499 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXJYV2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:28:17 -0400
Date: Thu, 25 Oct 2007 23:27:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Andrew Morton <akpm@linux-foundation.org>, nickpiggin@yahoo.com.au,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH v3] bitops kernel-doc: inline instead of macro
In-Reply-To: <20071025142149.6610f5ef.rdunlap@xenotime.net>
Message-ID: <alpine.LFD.0.9999.0710252325450.3186@localhost.localdomain>
References: <20071023220959.a359d57d.rdunlap@xenotime.net> <200710241800.19764.nickpiggin@yahoo.com.au> <20071025093159.3ea69d03.rdunlap@xenotime.net> <alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain> <20071025095540.827d4333.rdunlap@xenotime.net>
 <20071025134814.caced2e3.akpm@linux-foundation.org> <20071025142149.6610f5ef.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

On Thu, 25 Oct 2007, Randy Dunlap wrote:
> > We might as well clean stuff up as we're churning the code.
> > 
> > 
> > Andy, I thought we were going to whine about __inline__ and __inline, too?
> 
> Thomas, can you replace the previous patch with this one?

Sure. Darn, I did not run yours through the usual procedure :)

      tglx

> Usage of __inline__ is fixed in the next patch (after this one).
> 
 ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use duplicated inline functions for test_and_set_bit_lock() on x86
> instead of #define macros, thus avoiding a bad example.  This allows
> kernel-doc to run cleanly instead of terminating with an error:
> 
> Error(linux-2.6.24-rc1//include/asm-x86/bitops_32.h:188): cannot understand prototype: 'test_and_set_bit_lock test_and_set_bit '
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/asm-x86/bitops_32.h |    7 +++++--
>  include/asm-x86/bitops_64.h |    7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.24-rc1.orig/include/asm-x86/bitops_32.h
> +++ linux-2.6.24-rc1/include/asm-x86/bitops_32.h
> @@ -183,9 +183,12 @@ static inline int test_and_set_bit(int n
>   * @nr: Bit to set
>   * @addr: Address to count from
>   *
> - * This is the same as test_and_set_bit on x86
> + * This is the same as test_and_set_bit on x86.
>   */
> -#define test_and_set_bit_lock test_and_set_bit
> +static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
> +{
> +	return test_and_set_bit(nr, addr);
> +}
>  
>  /**
>   * __test_and_set_bit - Set a bit and return its old value
> --- linux-2.6.24-rc1.orig/include/asm-x86/bitops_64.h
> +++ linux-2.6.24-rc1/include/asm-x86/bitops_64.h
> @@ -173,9 +173,12 @@ static __inline__ int test_and_set_bit(i
>   * @nr: Bit to set
>   * @addr: Address to count from
>   *
> - * This is the same as test_and_set_bit on x86
> + * This is the same as test_and_set_bit on x86.
>   */
> -#define test_and_set_bit_lock test_and_set_bit
> +static __inline__ int test_and_set_bit_lock(int nr, volatile void *addr)
> +{
> +	return test_and_set_bit(nr, addr);
> +}
>  
>  /**
>   * __test_and_set_bit - Set a bit and return its old value
> 

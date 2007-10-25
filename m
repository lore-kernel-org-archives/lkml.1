Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbXJYRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbXJYRGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXJYRGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:06:08 -0400
Received: from www.tglx.de ([62.245.132.106]:46440 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXJYRGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:06:04 -0400
Date: Thu, 25 Oct 2007 19:05:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, mingo@redhat.com, hpa@zytor.com,
       lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] bitops kernel-doc: inline instead of macro
In-Reply-To: <20071025095540.827d4333.rdunlap@xenotime.net>
Message-ID: <alpine.LFD.0.9999.0710251905130.3186@localhost.localdomain>
References: <20071023220959.a359d57d.rdunlap@xenotime.net> <200710241800.19764.nickpiggin@yahoo.com.au> <20071025093159.3ea69d03.rdunlap@xenotime.net> <alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain>
 <20071025095540.827d4333.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Randy Dunlap wrote:

> > Hmm, can we simply do
> > 
> > static inline int test_and_set_bit_lock(int nr, volatile unsigned long * addr)
> > {
> > 	return test_and_set_bit(nr, addr);
> > }
> > 
> > please ?
> 
> Certainly.  That does look better.

Yup. Applied, thanks

     tglx

> ---
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
> +static inline int test_and_set_bit_lock(int nr, volatile unsigned long * addr)
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
> +static __inline__ int test_and_set_bit_lock(int nr, volatile void * addr)
> +{
> +	return test_and_set_bit(nr, addr);
> +}
>  
>  /**
>   * __test_and_set_bit - Set a bit and return its old value
> 

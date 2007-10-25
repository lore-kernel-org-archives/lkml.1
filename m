Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbXJYWBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbXJYWBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXJYWBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:01:24 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:35074 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752601AbXJYWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:01:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=m3G0s5uf0FDPU5zeEwGPHWnHQSCO3BBW/T4K1g86UkAUfXIMYs/4WSUrzWsNckZitV12oEYTyewqjEatY9BQTQyl8xNsTpbq77/LRfR5+l7YJ7btTayw6ns0iD/OMRbhpwHq51H3ISRYSo8jiA47+gmrtKgmZjuL9l35WVoDgYM=  ;
X-YMail-OSG: sYD.Ek0VM1m2FgeJf0QFWcXflAzwiSU.aeKBV2gLWZcOoeGrcph1PvCMcJnlkFdV5bq5hc5nGw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v2] bitops kernel-doc: inline instead of macro
Date: Fri, 26 Oct 2007 07:54:39 +1000
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
       lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
References: <20071023220959.a359d57d.rdunlap@xenotime.net> <alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain> <20071025095540.827d4333.rdunlap@xenotime.net>
In-Reply-To: <20071025095540.827d4333.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260754.40215.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 02:55, Randy Dunlap wrote:
> > Hmm, can we simply do
> >
> > static inline int test_and_set_bit_lock(int nr, volatile unsigned long *
> > addr) {
> > 	return test_and_set_bit(nr, addr);
> > }
> >
> > please ?
>
> Certainly.  That does look better.

Thanks!

>
> ---
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Use duplicated inline functions for test_and_set_bit_lock() on x86
> instead of #define macros, thus avoiding a bad example.  This allows
> kernel-doc to run cleanly instead of terminating with an error:
>
> Error(linux-2.6.24-rc1//include/asm-x86/bitops_32.h:188): cannot understand
> prototype: 'test_and_set_bit_lock test_and_set_bit '
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
> +static inline int test_and_set_bit_lock(int nr, volatile unsigned long *
> addr) +{
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

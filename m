Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXJXIHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXJXIHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXJXIHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:07:00 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:30454 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751086AbXJXIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:06:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tEi6eDAohEIBoFBUhQe8YqHvv75xdv77RuwT08btB7c8J4br3q3uM5jbsckwKN2Xv9vI/EY3VOzhrFdi0ZyGcKJh1kaM6OC6THyvdbvLfHzkhAl2Nt9eL0HS2Y1DgLs40rnm5lkk7QkRxnD6lHCbrPkGjvAE1cs0K+OVYVu7GuQ=  ;
X-YMail-OSG: e6A15N4VM1nUnwPYe4amOaprbSKDkdwv57.hNd1R65f2E71UUVULqALdTxL.K139e_.uxa2ydg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] bitops kernel-doc: expand macro
Date: Wed, 24 Oct 2007 18:00:19 +1000
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
References: <20071023220959.a359d57d.rdunlap@xenotime.net>
In-Reply-To: <20071023220959.a359d57d.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241800.19764.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 15:09, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Can we expand this macro definition, or should I look for a way to
> fool^W teach kernel-doc about this?
>
> scripts/kernel-doc says:
> Error(linux-2.6.24-rc1//include/asm-x86/bitops_32.h:188): cannot understand
> prototype: 'test_and_set_bit_lock test_and_set_bit '

Actually, it probably looks a bit nicer like this anyway. If you grep
for it, then you can actually see the parameters...

On third thoughts, an inline function might be the best thing to do,
and also avoid setting a bad example. What do you think?

>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/asm-x86/bitops_32.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.24-rc1.orig/include/asm-x86/bitops_32.h
> +++ linux-2.6.24-rc1/include/asm-x86/bitops_32.h
> @@ -185,7 +185,7 @@ static inline int test_and_set_bit(int n
>   *
>   * This is the same as test_and_set_bit on x86
>   */
> -#define test_and_set_bit_lock test_and_set_bit
> +#define test_and_set_bit_lock(nr, addr) test_and_set_bit(nr, addr)
>
>  /**
>   * __test_and_set_bit - Set a bit and return its old value
> ---

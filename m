Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYIBO2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYIBO2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYIBO1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:27:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:42880 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYIBO1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=dFOcotfWXafozFwRPNDu2ZLODxvv5O0x+adol7bIWIwQOXXyvaADfXpjTlf0KhFkvr
         kUePtH3pxH8J8l4k9vDZzi/mp6T6XdkdylO4Hk2zt6VaXWN6YX20eRd93jKtsgKjXnGr
         +u+Uozu3sguas9JGBp6I2HWtLJXLCQj5Q0ixI=
To: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/5 ver2] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
Date: Tue, 2 Sep 2008 16:27:47 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <48BBE77D.7070007@panasas.com> <200809011834.45856.IvDoorn@gmail.com> <48BD4BB3.7040808@panasas.com>
In-Reply-To: <48BD4BB3.7040808@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809021627.47977.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Mon, 1 Sep 2008 14:47:19 +0300
> Subject: [PATCH] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
> 
> A "Set" to a sign-bit in an "&" operation causes a compiler warning.
> Make calculations unsigned.
> 
> [ The warning was masked by the old definition of BUILD_BUG_ON() ]
> 
> Also remove __builtin_constant_p from FIELD_CHECK since BUILD_BUG_ON
> no longer permits non-const values.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> TO: Ivo van Doorn <IvDoorn@gmail.com>
> TO: John W. Linville <linville@tuxdriver.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Rusty Russell <rusty@rustcorp.com.au>

Thanks.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00reg.h |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
> index 7e88ce5..2ea7866 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
> @@ -136,7 +136,7 @@ struct rt2x00_field32 {
>   */
>  #define is_power_of_two(x)	( !((x) & ((x)-1)) )
>  #define low_bit_mask(x)		( ((x)-1) & ~(x) )
> -#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
> +#define is_valid_mask(x)	is_power_of_two(1LU + (x) + low_bit_mask(x))
>  
>  /*
>   * Macro's to find first set bit in a variable.
> @@ -173,8 +173,7 @@ struct rt2x00_field32 {
>   * does not exceed the given typelimit.
>   */
>  #define FIELD_CHECK(__mask, __type)			\
> -	BUILD_BUG_ON(!__builtin_constant_p(__mask) ||	\
> -		     !(__mask) ||			\
> +	BUILD_BUG_ON(!(__mask) ||			\
>  		     !is_valid_mask(__mask) ||		\
>  		     (__mask) != (__type)(__mask))	\
>  



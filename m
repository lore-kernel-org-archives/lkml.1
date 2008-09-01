Return-Path: <linux-kernel-owner+w=401wt.eu-S1751344AbYIAN1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbYIAN1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYIAN12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:27:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:3375 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYIAN11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=A5fPhGbxWWn3og2mcFNAsWd7c4SYwr+eH20F6XnTSGF5RHTLPfLua+/uzRinbAZURl
         nEIhSnaM9pQePyznZbFoWHxyJFg7ts18I+xVMV0/cs/DnOBdeR9uXmgXuvnOsQfr68Yo
         z0MoOL/0DMUNsd5Spedtw645Ej1tlKi0wxrUg=
Message-ID: <48BBEDB8.1030400@gmail.com>
Date: Mon, 01 Sep 2008 16:27:20 +0300
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
References: <48BBE77D.7070007@panasas.com> <48BBEC6C.1050301@panasas.com>
In-Reply-To: <48BBEC6C.1050301@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: Benny Halevy <bhalevy@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep. 01, 2008, 16:21 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> A "Set" of the sign-bit in an "&" operation causes a compiler warning.
> Make calculations unsigned.
> 
> [ The warning was masked by the use of (void)() cast in the old
>   BUILD_BUG_ON() ]
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> TO: Ivo van Doorn <IvDoorn@gmail.com>
> TO: John W. Linville <linville@tuxdriver.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/net/wireless/rt2x00/rt2x00reg.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
> index 7e88ce5..c0e8706 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
> @@ -134,8 +134,8 @@ struct rt2x00_field32 {
>   * Note that we cannot use the is_power_of_2() function since this
>   * check must be done at compile-time.
>   */
> -#define is_power_of_two(x)	( !((x) & ((x)-1)) )
> -#define low_bit_mask(x)		( ((x)-1) & ~(x) )
> +#define is_power_of_two(x)	( !((unsigned)(x) & ((x)-1)) )
> +#define low_bit_mask(x)		( ((unsigned)(x)-1) & ~(x) )

Why not unsigned long?

Benny

>  #define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
>  
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


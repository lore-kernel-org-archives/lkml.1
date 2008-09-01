Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYIAOCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYIAOCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYIAOBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:01:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:26808 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYIAOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xA/o75XlV1APNNdeCMgQr1am4eFSrXputD0J8fPY0LvgnXl7qZlNFdI54GLwQaqx1R
         JVkb6YU0R+IqKt79q8+/v9VhwBeRaTEqnq2SwqHfX0zeT/Xu4ipPy9teWZiwuu0Gpse7
         8LzUM08mBYQGHpY5wdPryreVIlo2KJigfPY3o=
Message-ID: <a32f33a40809010701o1069afdfuc2745f934753fb2e@mail.gmail.com>
Date: Mon, 1 Sep 2008 16:01:53 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH 4/5 ver2] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Beulich" <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48BBF1DA.5060808@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48BBE77D.7070007@panasas.com> <48BBEC6C.1050301@panasas.com>
	 <48BBF1DA.5060808@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2008 at 3:44 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> A "Set" of a sign-bit in an "&" operation causes a compiler warning.
> Make calculations unsigned.
>
> [ The warning was masked by the use of (void)() cast in the old
>  BUILD_BUG_ON() ]
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
> index 7e88ce5..e71b793 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
> @@ -136,8 +136,8 @@ struct rt2x00_field32 {
>  */
>  #define is_power_of_two(x)     ( !((x) & ((x)-1)) )
>  #define low_bit_mask(x)                ( ((x)-1) & ~(x) )
> -#define is_valid_mask(x)       is_power_of_two(1 + (x) + low_bit_mask(x))
> -
> +#define is_valid_mask(x)       is_power_of_two(1 + (x) + \
> +                                       low_bit_mask((unsigned long)x))

I know I typed it wrong, but you are missing the unsigned long cast for the
is_power_of_two argument here (Which could also be done in the
is_valid_mask() definition).

>  /*
>  * Macro's to find first set bit in a variable.
>  * These macro's behaves the same as the __ffs() function with
> --
> 1.5.6.rc1.5.gadf6
>
>
>

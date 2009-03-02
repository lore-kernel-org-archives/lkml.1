Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZCBPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZCBPvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZCBPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:51:04 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:41386 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZCBPvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IXfk7K+cQJ68f7f/Lm6W6j4fpne91GM5GPyzShTCjjE/2ZZGXejeyvHipRAINM5H6v
         NBzqEengl30lEIroEvcpBgzMqG5EmxZiuUW+IQycpUWvsK2mKovol/A+W5mADWyBV9AP
         vsgnP4nvScK5eNy7/lYLLHApw54iDBINrB7gs=
MIME-Version: 1.0
In-Reply-To: <1236007103.18284.83.camel@penberg-laptop>
References: <1236007103.18284.83.camel@penberg-laptop>
Date: Mon, 2 Mar 2009 12:50:59 -0300
Message-ID: <82ecf08e0903020750q3670de6u4162e4f01c847003@mail.gmail.com>
Subject: Re: [PATCH] crc32: remove useless __pure modifier from functions
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, the effects of most keywords (like const, etc) affect things
outside of the module (the callers)

http://gcc.gnu.org/onlinedocs/gcc-4.2.0/gcc/Function-Attributes.html
has a good explanation.

Briefly, a _pure function only depends on its parameters and the only
return is via the function return, so the compiler can optimize some
of its calls away.

-- 
-
Thiago Galesi



On Mon, Mar 2, 2009 at 12:18 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> The pure attribute has absolutely no effect with GCC 4.2:
>
>   text    data     bss     dec     hex filename
>   2456       0       0    2456     998 lib/crc32.o.old
>   2456       0       0    2456     998 lib/crc32.o.new
>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  lib/crc32.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/lib/crc32.c b/lib/crc32.c
> index 49d1c9e..9ff76ad 100644
> --- a/lib/crc32.c
> +++ b/lib/crc32.c
> @@ -49,7 +49,7 @@ MODULE_LICENSE("GPL");
>  * @p: pointer to buffer over which CRC is run
>  * @len: length of buffer @p
>  */
> -u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
> +u32 crc32_le(u32 crc, unsigned char const *p, size_t len);
>
>  #if CRC_LE_BITS == 1
>  /*
> @@ -57,7 +57,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
>  * simplified by inlining the table in ?: form.
>  */
>
> -u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
> +u32 crc32_le(u32 crc, unsigned char const *p, size_t len)
>  {
>        int i;
>        while (len--) {
> @@ -69,7 +69,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
>  }
>  #else                          /* Table-based approach */
>
> -u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
> +u32 crc32_le(u32 crc, unsigned char const *p, size_t len)
>  {
>  # if CRC_LE_BITS == 8
>        const u32      *b =(u32 *)p;
> @@ -145,7 +145,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
>  * @p: pointer to buffer over which CRC is run
>  * @len: length of buffer @p
>  */
> -u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
> +u32 crc32_be(u32 crc, unsigned char const *p, size_t len);
>
>  #if CRC_BE_BITS == 1
>  /*
> @@ -153,7 +153,7 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
>  * simplified by inlining the table in ?: form.
>  */
>
> -u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
> +u32 crc32_be(u32 crc, unsigned char const *p, size_t len)
>  {
>        int i;
>        while (len--) {
> @@ -167,7 +167,7 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
>  }
>
>  #else                          /* Table-based approach */
> -u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
> +u32 crc32_be(u32 crc, unsigned char const *p, size_t len)
>  {
>  # if CRC_BE_BITS == 8
>        const u32      *b =(u32 *)p;
> --
> 1.5.4.3
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

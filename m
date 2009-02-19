Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZBSBz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZBSBz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZBSBzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:55:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:38695 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZBSBzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dQAwJhtIf4Jij+liiQxkZQRc4xN9LztURpSbBGDK/GLnbubr+xeZOhcQY96Ib0vH8S
         pLtoov4wPBJSAbePoJvfTwbjm8A3lrK3Dz8CNBegG9Ru9Tk/wq3Vae/mb2d1InZvoFWF
         jZ/+HZ9UpAy8mFblh0dbJtwtFPjD5JHdBMtug=
MIME-Version: 1.0
In-Reply-To: <200902190929.42044.rusty@rustcorp.com.au>
References: <20090218191640.0b023029.sfr@canb.auug.org.au>
	 <20090218224541.fe6e0355.sfr@canb.auug.org.au>
	 <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
	 <200902190929.42044.rusty@rustcorp.com.au>
Date: Wed, 18 Feb 2009 20:55:13 -0500
Message-ID: <8bd0f97a0902181755y5a5f6760s6e266c87906e6dca@mail.gmail.com>
Subject: Re: [s390] next Feb 18: defconfig build break
From: Mike Frysinger <vapier.adi@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Sachin P. Sant" <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 17:59, Rusty Russell wrote:
> On Thursday 19 February 2009 03:40:59 Mike Frysinger wrote:
>> breaks all Blackfin ports as well:
>> In file included from include/linux/bitmap.h:9,
>>                  from include/linux/nodemask.h:90,
>>                  from include/linux/mmzone.h:17,
>>                  from include/linux/gfp.h:5,
>>                  from include/linux/kmod.h:23,
>>                  from include/linux/module.h:14,
>>                  from arch/blackfin/lib/strncmp.c:14:
>> include/linux/string.h: In function 'strstarts':
>> include/linux/string.h:124: error: implicit declaration of function 'strncmp'
>> make[1]: *** [arch/blackfin/lib/strncmp.o] Error 1
>> make: *** [arch/blackfin/lib] Error 2
>
>   I don't have a blackfin cross compiler, but I think this is the right
> fix:

np ... fix is almost correct :)

> --- a/arch/blackfin/lib/strncmp.c
> +++ b/arch/blackfin/lib/strncmp.c
> @@ -6,6 +6,7 @@
>  * Licensed under the GPL-2 or later.
>  */
>
> +int strncmp(const char *cs, const char *ct, size_t count);
>  #define strncmp __inline_strncmp
>  #include <asm/string.h>
>  #undef strncmp
> diff --git a/arch/blackfin/lib/strncpy.c b/arch/blackfin/lib/strncpy.c
> --- a/arch/blackfin/lib/strncpy.c
> +++ b/arch/blackfin/lib/strncpy.c
> @@ -6,6 +6,7 @@
>  * Licensed under the GPL-2 or later.
>  */
>
> +char *strncpy(char *dest, const char *src, size_t n);
>  #define strncpy __inline_strncpy
>  #include <asm/string.h>
>  #undef strncpy

size_t is not a builtin type so there needs to be a linux/types.h
include right above these two prototypes.  then things build up fine
for me.

thanks!
-mike

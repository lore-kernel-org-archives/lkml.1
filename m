Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbXJYPFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbXJYPFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbXJYPFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:05:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39108 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758557AbXJYPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:05:17 -0400
Date: Thu, 25 Oct 2007 17:05:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Jie Zhang <jzhang.linux@gmail.com>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Message-ID: <20071025150545.GK30533@stusta.de>
References: <20071024162643.GP30533@stusta.de> <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com> <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com> <47200826.1060801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47200826.1060801@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 08:06:14PM -0700, H. Peter Anvin wrote:
> Mike Frysinger wrote:
>> On 10/24/07, Jie Zhang <jzhang.linux@gmail.com> wrote:
>>> On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
>>>> "extern inline" will have different semantics with gcc 4.3.
>>>>
>>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>>>
>>>> --- a/include/asm-blackfin/string.h
>>>> +++ b/include/asm-blackfin/string.h
>>>> @@ -4,7 +4,7 @@
>>>>  #ifdef __KERNEL__              /* only set these up for kernel code */
>>>>
>>>>  #define __HAVE_ARCH_STRCPY
>>>> -extern inline char *strcpy(char *dest, const char *src)
>>>> +static inline char *strcpy(char *dest, const char *src)
>>>>  {
>>>>         char *xdest = dest;
>>>>         char temp = 0;
>>> What if we compile it with gcc 4.1?
>> we'll have to either use the gcc attributes to force old inline
>> behavior or use the gcc flag to force it
>
> We should probably have an extern_inline define then, assuming this is a 
> function that does exist in a linkable version already -- otherwise "static 
> inline" is correct.

Since we #define inline to be __attribute__((always_inline))
"extern inline" with the old semantics would only behave differently
if someone took the address of one of these string functions.

Does this happen anywhere in the blackfin port?

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


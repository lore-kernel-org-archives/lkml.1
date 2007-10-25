Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbXJYDGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbXJYDGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXJYDGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:06:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbXJYDGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:06:34 -0400
Message-ID: <47200826.1060801@zytor.com>
Date: Wed, 24 Oct 2007 20:06:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Jie Zhang <jzhang.linux@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
References: <20071024162643.GP30533@stusta.de>	 <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com> <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>
In-Reply-To: <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 10/24/07, Jie Zhang <jzhang.linux@gmail.com> wrote:
>> On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
>>> "extern inline" will have different semantics with gcc 4.3.
>>>
>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>>
>>> --- a/include/asm-blackfin/string.h
>>> +++ b/include/asm-blackfin/string.h
>>> @@ -4,7 +4,7 @@
>>>  #ifdef __KERNEL__              /* only set these up for kernel code */
>>>
>>>  #define __HAVE_ARCH_STRCPY
>>> -extern inline char *strcpy(char *dest, const char *src)
>>> +static inline char *strcpy(char *dest, const char *src)
>>>  {
>>>         char *xdest = dest;
>>>         char temp = 0;
>> What if we compile it with gcc 4.1?
> 
> we'll have to either use the gcc attributes to force old inline
> behavior or use the gcc flag to force it

We should probably have an extern_inline define then, assuming this is a 
function that does exist in a linkable version already -- otherwise 
"static inline" is correct.

	-hpa

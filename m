Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYCMKPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYCMKPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYCMKNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:13:34 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46069 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755153AbYCMKNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:13:33 -0400
Date: Thu, 13 Mar 2008 11:13:31 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: zippel@linux-m68k.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] introduce explicit signed/unsigned 64bit divide
In-Reply-To: <20080313004902.808083566@linux-m68k.org>
Message-ID: <Pine.LNX.4.64.0803131110520.9727@vixen.sonytel.be>
References: <20080313002235.351414762@linux-m68k.org> <20080313004902.808083566@linux-m68k.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1444836469-1205403154=:9727"
Content-ID: <Pine.LNX.4.64.0803131112490.9727@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1444836469-1205403154=:9727
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0803131112491.9727@vixen.sonytel.be>

On Thu, 13 Mar 2008, zippel@linux-m68k.org wrote:
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/include/linux/math64.h	2008-03-12 21:21:26.000000000 +0100
> @@ -0,0 +1,72 @@
> +#ifndef _LINUX_MATH64_H
> +#define _LINUX_MATH64_H
> +
> +#include <linux/types.h>
> +#include <asm/div64.h>
> +
> +#if BITS_PER_LONG == 64
> +
> +/**
> + * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
> + *
> + * This is commonly provided by 32bit archs to provide an optimized 64bit
> + * divide.
> + */
> +static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
> +{
> +	*remainder = dividend % divisor;
> +	return dividend / divisor;
> +}
> +
> +/**
> + * div_s64_rem - signed 64bit divide with 32bit divisor with remainder
> + */
> +static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
                 ^       ^       ^             ^            ^
		 s64 div_s64_rem s64           s32          s32
> +{
> +	*remainder = dividend % divisor;
> +	return dividend / divisor;
> +}
> +
> +#elif BITS_PER_LONG == 32
> +
> +#ifndef div_u64_rem
> +static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
> +{
> +	*remainder = do_div(dividend, divisor);
> +	return dividend;
> +}
> +#endif
> +
> +#ifndef div_s64_rem
> +extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
> +#endif

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-1444836469-1205403154=:9727--

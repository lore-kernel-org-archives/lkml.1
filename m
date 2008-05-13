Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbYEMLRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbYEMLRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYEMLRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:17:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53144 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYEMLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:17:14 -0400
Message-Id: <1210677433.22341.1252875863@webmail.messagingengine.com>
X-Sasl-Enc: Ceo2VuBEs05NHn4s3CR+P3D6o8HMm1/5V1YSX0yglWVR 1210677433
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: nickolay@protei.ru, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <481E076A.8060302@protei.ru>
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
In-Reply-To: <481E076A.8060302@protei.ru>
Date: Tue, 13 May 2008 13:17:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> bugfix in fls64 on a big endian systems(against 2.6.25).
> 
> Signed-off-by: Nickolay Vinogradov <nickolay@protei.ru>
> 
> --
> 
> diff --git a/include/asm-generic/bitops/fls64.h 
> b/include/asm-generic/bitops/fls64.h
> index 1b6b17c..2eedb6f 100644
> --- a/include/asm-generic/bitops/fls64.h
> +++ b/include/asm-generic/bitops/fls64.h
> @@ -8,7 +8,7 @@ static inline int fls64(__u64 x)
>          __u32 h = x >> 32;
>          if (h)
>                  return fls(h) + 32;
> -       return fls(x);
> +       return fls((__u32)x);
>   }

Hi Nickolay,

The change is ok, I guess, but the cast should be a no-op (fls
takes an int, which is always 32 bit in linux). What is the problem
you are seeing? Does fls64() return a wrong value in some cases? If
so, what cpu? Which values?

Why would this be a bug on big endian systems only? There is no
pointer magic involved, so the compiler should take care of the
casts in a correct way.

Maybe you see a compiler warning? Which compiler version?

(also note that current (development) kernels now have separate
versions for 32-bit and 64-bit environments.)

Greetings,
    Alexander

>   #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */
> 
> -- 
> Nickolay Vinogradov
> Protei Research and Development Center
> St.Petersburg, 194044, Russia
> Tel.: +7 812 449 47 27
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYELVqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYELVqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYELVqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:46:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbYELVp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:45:59 -0400
Date: Mon, 12 May 2008 14:45:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F?=
	 =?ISO-8859-1?Q?=5F=5F_=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F_=5F=5F?=
	 =?ISO-8859-1?Q?=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F?= 
	<nickolay@protei.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
Message-Id: <20080512144507.8d770723.akpm@linux-foundation.org>
In-Reply-To: <481E076A.8060302@protei.ru>
References: <481E076A.8060302@protei.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 May 2008 22:58:50 +0400
____________________ ______________ ____________________ <nickolay@protei.ru> wrote:

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
> 
>   #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */

Please describe the bug which you are fixing?

Perhaps a more robust fix to <whatever the bug is> would be to
repair fls() so that it works correctly when passed a u64.  Perhaps.

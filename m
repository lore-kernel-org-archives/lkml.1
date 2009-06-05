Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZFEGwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZFEGwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZFEGv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:51:58 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59432 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZFEGv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:51:58 -0400
Message-Id: <200906050651.n556p7Vo094549@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       andreas.herrmann3@amd.com, mingo@elte.hu
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 15:51:07 +0900
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp> <20090605023835.GA7933@cr0.nay.redhat.com> <20090604201733.746928c6.akpm@linux-foundation.org> <200906050339.n553d684048041@www262.sakura.ne.jp> <20090604205103.bbfe9af2.akpm@linux-foundation.org> <200906050400.n5540Sx0052981@www262.sakura.ne.jp> <20090604212018.b9e9f354.akpm@linux-foundation.org>
In-Reply-To: <20090604212018.b9e9f354.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05062009 #2087110, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> We could do the obvious:
> 
> --- a/arch/x86/mm/memtest.c~a
> +++ a/arch/x86/mm/memtest.c
> @@ -8,6 +8,7 @@
>  #include <linux/pfn.h>
>  
>  #include <asm/e820.h>
> +#include <asm/div64.h>
>  
>  static u64 patterns[] __initdata = {
>  	0,
> @@ -48,7 +49,8 @@ static void __init memtest(u64 pattern, 
>  
>  	incr = sizeof(pattern);
>  	start_phys_aligned = ALIGN(start_phys, incr);
> -	count = (size - (start_phys_aligned - start_phys))/incr;
> +	count = size - (start_phys_aligned - start_phys);
> +	do_div(count, incr);
>  	start = __va(start_phys_aligned);
>  	start_bad = 0;
>  	last_bad = 0;

"make" of "make allmodconfig" + CONFIG_KVM=n on gcc 3.3.5 completed
successfully.

>but I wonder why all those things are u64.  They all hold virtual
>addresses, don't they?  The code doesn't test highmem.  So shouldn't
>these all be unsigned longs?
memtest() in linux-2.6.29.4/arch/x86/mm/memtest.c is using "unsigned long".
2.6.30 changed to use "u64" by some reason.

Thank you.

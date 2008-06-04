Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbYFDWrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbYFDWrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYFDWro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:47:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYFDWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:47:43 -0400
Message-ID: <48471B68.3050103@zytor.com>
Date: Wed, 04 Jun 2008 15:47:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: e820 max_arch_pfn typo fix for 64 bit
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031934.01198.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com> <200806041321.30083.yhlu.kernel@gmail.com>
In-Reply-To: <200806041321.30083.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> should use right shift
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -771,7 +771,7 @@ u64 __init early_reserve_e820(u64 startt
>  #  define MAX_ARCH_PFN		(1ULL<<(32-PAGE_SHIFT))
>  # endif
>  #else /* CONFIG_X86_32 */
> -# define MAX_ARCH_PFN MAXMEM<<PAGE_SHIFT
> +# define MAX_ARCH_PFN MAXMEM>>PAGE_SHIFT
>  #endif
>  

Should also use parens (operator inside a macro).

	-hpa

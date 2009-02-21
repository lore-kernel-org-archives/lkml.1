Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZBUQZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZBUQZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZBUQZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:25:25 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58413 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZBUQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:25:24 -0500
Message-ID: <49A029F9.40902@cs.helsinki.fi>
Date: Sat, 21 Feb 2009 18:21:13 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kmemcheck: disable fast string operations on P4 CPUs
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com> <1235223364-2097-2-git-send-email-vegard.nossum@gmail.com>
In-Reply-To: <1235223364-2097-2-git-send-email-vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> This patch may allow us to remove the REP emulation code from
> kmemcheck.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> +#ifdef CONFIG_KMEMCHECK
> +	/*
> +	 * P4s have a "fast strings" feature which causes single-
> +	 * stepping REP instructions to only generate a #DB on
> +	 * cache-line boundaries.
> +	 *
> +	 * Ingo Molnar reported a Pentium D (model 6) and a Xeon
> +	 * (model 2) with the same problem.
> +	 */

Minor nit: I'd move the latter part of the comment to the changelog.

> +	if (c->x86 == 15) {
> +		u64 misc_enable;
> +
> +		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +
> +		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> +			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
> +
> +			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> +			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +		}
> +	}
> +#endif
>  }
>  
>  #ifdef CONFIG_X86_32


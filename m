Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYJEAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYJEAnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 20:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYJEAnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 20:43:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbYJEAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 20:43:07 -0400
Message-ID: <48E80D80.2090900@zytor.com>
Date: Sat, 04 Oct 2008 17:42:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup: print out correct type
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
> +++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
> @@ -1273,12 +1273,14 @@ static int __init mtrr_cleanup(unsigned
>  		size_base = to_size_factor(size_base, &size_factor),
>  		start_base = range_state[i].base_pfn << (PAGE_SHIFT - 10);
>  		start_base = to_size_factor(start_base, &start_factor),
> +		type = range_state[i].type;
>  
>  		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
>  			i, start_base, start_factor,
>  			size_base, size_factor,
>  			(type == MTRR_TYPE_UNCACHABLE) ? "UC" :
> -			    ((type == MTRR_TYPE_WRBACK) ? "WB" : "Other")
> +			    ((type == MTRR_TYPE_WRPROT) ? "WPROT" :
> +			     ((type == MTRR_TYPE_WRBACK) ? "WB" : "Other"))
>  			);

If you're going to abbreviate, please use the standard abbreviations as 
documented in the manuals.  The abbreviation for write protect is WP.

	-hpa

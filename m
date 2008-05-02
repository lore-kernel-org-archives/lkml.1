Return-Path: <linux-kernel-owner+w=401wt.eu-S936065AbYEBT2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065AbYEBT2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbYEBT2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:28:01 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:55930 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947AbYEBT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:28:00 -0400
Message-ID: <481B6B3D.9060200@grupopie.com>
Date: Fri, 02 May 2008 20:27:57 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Greg Ungerer <gerg@snapgear.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: add pretty back strace
References: <200805010216.m412GcUQ004101@goober>
In-Reply-To: <200805010216.m412GcUQ004101@goober>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer wrote:
> From: Sebastian Siewior <bigeasy@linutronix.de>
> 
> With this patch and
>  CONFIG_FRAME_POINTER=y
>  CONFIG_KALLSYMS=y
> The backtrace shows resolved function names and their numeric
> address.

This is really not my area, but this patch reminds me of all the dwarf2 
unwinder on x86 that caused so many problems in the beginning...

> [...]
> +#ifdef CONFIG_FRAME_POINTER
> +	printk(KERN_EMERG "Call Trace:\n");
> +
> +	last_stack = stack - 1;
> +	while (stack <= endstack && stack > last_stack) {
> +
> +		addr = *(stack + 1);
> +		printk(KERN_EMERG " [%08lx] ", addr);
> +		print_symbol(KERN_CONT "%s\n", addr);
> +
> +		last_stack = stack;
> +		stack = (unsigned long *)*stack;
>  	}
>  	printk("\n");
> +#else
> +	printk(KERN_EMERG "CONFIG_FRAME_POINTER disabled, no symbolic call trace\n");

You could probably fall back to the old method in this case, no?

Also, if the stack is slightly corrupted on the top, the new method 
might just bail out without giving any indication about the path that 
lead there, when instead it could also fall back to the old method.

-- 
Paulo Marques - www.grupopie.com

"Feed the hungry, save the whales, free the mallocs!"

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXIVCfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXIVCfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 22:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXIVCfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 22:35:33 -0400
Received: from barikada.upol.cz ([158.194.242.200]:56475 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbXIVCfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 22:35:32 -0400
To: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, xemul@openvz.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Killing printk calls for size (Re: [PATCH] [6/50] i386: clean up oops/bug reports)
In-Reply-To: <20070921223204.43B8413DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de> <20070921223204.43B8413DCD@wotan.suse.de>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sat, 22 Sep 2007 04:51:08 +0200
Message-Id: <E1IYv5I-0003zr-TX@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 22 Sep 2007 00:32:04 +0200 (CEST)
[]
>  arch/i386/kernel/traps.c |   16 ++++------------
>  arch/i386/mm/fault.c     |   13 +++++++------
>  2 files changed, 11 insertions(+), 18 deletions(-)

It seems, like size can be reduced even more now:

[]
>  		report_bug(regs->eip, regs);
>  
> -		printk(KERN_EMERG "%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
> +		printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);

  +		printk(KERN_EMERG "%s: %04lx [#%d] %s", str, err &0xffff, ++die_counter,

>  #ifdef CONFIG_PREEMPT
> -		printk(KERN_EMERG "PREEMPT ");
> -		nl = 1;
> +		printk("PREEMPT ");

  +		"PREEMPT "\

>  #endif
>  #ifdef CONFIG_SMP
> -		if (!nl)
> -			printk(KERN_EMERG);
>  		printk("SMP ");

  		"SMP "\

> -		nl = 1;
>  #endif
>  #ifdef CONFIG_DEBUG_PAGEALLOC
> -		if (!nl)
> -			printk(KERN_EMERG);
>  		printk("DEBUG_PAGEALLOC");

  		"DEBUG_PAGEALLOC"\

> -		nl = 1;
>  #endif
> -		if (nl)
> -			printk("\n");
> +		printk("\n");

  +		"\n");

Just hand waving.

FWIW, with more flexible kconfig, ifdiffery can be removed also...
____

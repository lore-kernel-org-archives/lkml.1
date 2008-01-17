Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbYAQQhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbYAQQhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 11:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYAQQg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 11:36:56 -0500
Received: from waste.org ([66.93.16.53]:49231 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYAQQgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 11:36:55 -0500
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c
	compiling
From: Matt Mackall <mpm@selenic.com>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200801171643.49301.michael-lists@free-electrons.com>
References: <200801171643.49301.michael-lists@free-electrons.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 10:36:14 -0600
Message-Id: <1200587774.5332.11.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 16:43 +0100, Michael Opdenacker wrote:
> [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c compiling
> 
> Applies to 2.6.24-rc8-git1
> 
> This patch results from Linux Tiny's efforts to hunt for unnecessary
> code added unconditionally with "obj-y +="
> 
> This patch make the compilation of arch/x86/kernel/pcspeaker.c
> depend on PC speaker support. Before that, this file was always
> compiled even if pc speaker support wasn't enabled.
> 
> I'm checking that CONFIG_INPUT_PCSPKR is not set to "m",
> as arch/x86/kernel/pcspeaker.c shouldn't be compiled as a module:
> - It defines no init and exit functions
> - It defines an initcall which only makes sense at
>   kernel boot time.
> 
> Results: if PC speaker support is disabled
> - It reduces the uncompressed kernel size by 218 bytes!!! ;)
> - It must also bring a tiny reduction in boot time
>   but suppressing a useless initcall.
> 
> Your comments?
> 
> ---
> Signed-off-by: Michael Opdenacker <michael@free-electrons.com>
> 
> diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32
> --- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32	2008-01-17 09:48:58.000000000 +0100
> +++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32	2008-01-17 10:06:56.000000000 +0100
> @@ -45,10 +45,13 @@
>  
>  obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
>  obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
> -obj-y				+= pcspeaker.o
> -
>  obj-$(CONFIG_SCx200)		+= scx200_32.o
>  
> +ifeq ($(CONFIG_INPUT_PCSPKR),y)
> +	obj-y			+= pcspeaker.o
> +endif

I'm not sure this does what you want. What if CONFIG_INPUT_PCSPKR = m?

You ought to cc: this to Ingo (added). I'm pretty sure these Makefiles
have been unified in x86.git already.

-- 
Mathematics is the supreme nostalgia of our time.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbXJYXa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbXJYXa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbXJYXav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:30:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:62533 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbXJYXau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CjkxIE+/YgkNeyg73mTeOtrlSjt5Yji81uL74TKkFqC0mdzcgHI2Uft2nMK6FhTIROgo65rwLnYIw8QVF3Tm1z1ONIbKk1nsU436wpafTwoG3qOUx2pyjZajwioHLukrGp2S50z1slTx/JQ6cgJi6z89YYFy3YG6UpXEcXec3BE=
Message-ID: <86802c440710251630j71b9f750j2e0fbe4c9b37165e@mail.gmail.com>
Date: Thu, 25 Oct 2007 16:30:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 3/6] x86: unification of i386 and x86_64 Kconfig.debug
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <20071025200434.GD14501@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025195644.GA14501@uranus.ravnborg.org>
	 <20071025200434.GD14501@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> From 16b853f53463e43bfce341965ac10a78a3755a14 Mon Sep 17 00:00:00 2001
> From: Randy Dunlap <rdunlap@xenotime.net>
> Date: Wed, 24 Oct 2007 15:50:43 -0700
> Subject: [PATCH] x86: unification of i386 and x86_64 Kconfig.debug
>
> Adding proper dependencies so the two Kconfig.debug files
> are now identical.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/i386/Kconfig.debug             |   51 ++++++++++++++++++++++++++++-------
>  arch/x86_64/Kconfig                 |    4 ---
>  arch/{i386 => x86_64}/Kconfig.debug |   51 ++++++++++++++++++++++++++++-------
>  3 files changed, 82 insertions(+), 24 deletions(-)
>  copy arch/{i386 => x86_64}/Kconfig.debug (65%)
>
> diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
> index f03531e..970b2de 100644
> --- a/arch/i386/Kconfig.debug
> +++ b/arch/i386/Kconfig.debug
> @@ -1,14 +1,14 @@
>  menu "Kernel hacking"
>
>  config TRACE_IRQFLAGS_SUPPORT
> -       bool
> -       default y
> +       def_bool y
>
>  source "lib/Kconfig.debug"
>
>  config EARLY_PRINTK
>         bool "Early printk" if EMBEDDED && DEBUG_KERNEL
>         default y
> +       depends on X86_32
>         help
>           Write kernel log output directly into the VGA buffer or to a serial
>           port.
> @@ -37,10 +37,12 @@ config DEBUG_STACK_USAGE
...
> diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> index 308970a..1bc0268 100644
> --- a/arch/x86_64/Kconfig
> +++ b/arch/x86_64/Kconfig
> @@ -97,10 +97,6 @@ config X86_CMPXCHG
>         bool
>         default y
>
> -config EARLY_PRINTK
> -       bool
> -       default y
> -
>  config GENERIC_ISA_DMA
>         bool
>         default y
> diff --git a/arch/i386/Kconfig.debug b/arch/x86_64/Kconfig.debug
> similarity index 65%
> copy from arch/i386/Kconfig.debug
> copy to arch/x86_64/Kconfig.debug
> index f03531e..970b2de 100644
> --- a/arch/i386/Kconfig.debug
> +++ b/arch/x86_64/Kconfig.debug
> @@ -1,14 +1,14 @@
>  menu "Kernel hacking"
>
>  config TRACE_IRQFLAGS_SUPPORT
> -       bool
> -       default y
> +       def_bool y
>
>  source "lib/Kconfig.debug"
>
>  config EARLY_PRINTK
>         bool "Early printk" if EMBEDDED && DEBUG_KERNEL
>         default y
> +       depends on X86_32
>         help
>           Write kernel log output directly into the VGA buffer or to a serial
>           port.
...

why disabling early_printk for x86_64?

YH

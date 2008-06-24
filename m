Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYFZIUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYFZIUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbYFZITX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:19:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2609 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755035AbYFZITU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:19:20 -0400
Date: Tue, 24 Jun 2008 14:12:34 +0200
From: Pavel Machek <pavel@suse.cz>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: check command line when CONFIG_X86_MPPARSE is not set
Message-ID: <20080624121234.GB5642@ucw.cz>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806191213.10312.yhlu.kernel@gmail.com> <200806191215.01538.yhlu.kernel@gmail.com> <200806200742.36226.yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806200742.36226.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> we can not use acpi=off, acpi=noirq and pci=noacpi when mps support is
> not there
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/acpi/boot.c |   12 ++++++++++++
>  arch/x86/kernel/setup_32.c  |    2 ++
>  arch/x86/kernel/setup_64.c  |    2 ++
>  include/linux/acpi.h        |    5 +++++
>  4 files changed, 21 insertions(+)
> 
> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
> @@ -1740,6 +1740,18 @@ static int __init parse_pci(char *arg)
>  }
>  early_param("pci", parse_pci);
>  
> +void __init acpi_mps_check(void)
> +{
> +#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_X86_MPPARSE)
> +/* mptable code is not built-in*/
> +	if (acpi_disabled || acpi_noirq) {
> +		printk(KERN_ERR "MPS support code is not built-in\n",
> +		       "so can not use acpi=off or acpi=noirq or pci=noacpi\n");
> +		panic("MPS support is not built-in\n");
> +	}
> +#endif

I'd say this is good enough reason not to make X86_MPPARSE optional.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

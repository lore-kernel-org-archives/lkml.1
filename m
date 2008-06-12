Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbYFLWmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbYFLWmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYFLWmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:42:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56978 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753437AbYFLWmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:42:23 -0400
Message-ID: <4851A64E.9040908@sgi.com>
Date: Thu, 12 Jun 2008 15:42:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
References: <20080612223802.528617000@polaris-admin.engr.sgi.com> <20080612223802.673729000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080612223802.673729000@polaris-admin.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boy, this just isn't my day... Another typo slipped through...


Mike Travis wrote:
>  * Add config option EARLY_SERIAL_CONSOLE to enable early
>    printk's to be directed to the serial console.
> 
> Based on linux-next
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> 
> ---
>  arch/x86/Kconfig.debug         |    9 +++++++++
>  arch/x86/kernel/early_printk.c |    4 ++++
>  2 files changed, 13 insertions(+)
> 
> --- linux-2.6-next.orig/arch/x86/Kconfig.debug
> +++ linux-2.6-next/arch/x86/Kconfig.debug
> @@ -29,6 +29,15 @@ config EARLY_PRINTK
>  	  with klogd/syslogd or the X server. You should normally N here,
>  	  unless you want to debug such a crash.
>  
> +config EARLY_SERIAL_CONSOLE
> +	bool "Early Serial Console"
> +	default m
> +	help
> +	  Initializes the early console to be the serial port.  The default
> +	  is to use the VGA console.
> +
> +	  This is useful for server systems that do not have a VGA console.
> +
>  config DEBUG_STACKOVERFLOW
>  	bool "Check for stack overflows"
>  	depends on DEBUG_KERNEL
> --- linux-2.6-next.orig/arch/x86/kernel/early_printk.c
> +++ linux-2.6-next/arch/x86/kernel/early_printk.c
> @@ -193,7 +193,11 @@ static struct console simnow_console = {
>  };
>  
>  /* Direct interface for emergencies */
> +#ifdef CONFIG_EARLY_SERIAL_CONSOLE
> +static struct console *early_console = &early_serial_console;
> +#else
>  static struct console *early_console = &early_vga_console;
> +#endif
>  static int early_console_initialized;
>  
>  void early_printk(const char *fmt, ...)
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761082AbYFLWsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082AbYFLWsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760376AbYFLWsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:48:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:10297 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421AbYFLWsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jmW9Zr4zEcsmqbJi21FYWv+sDamVwg+VJxRgWvuMgnQ6UdeMJw29WsTLpNksa9H52Z
         5Xw+YIGSNlWzfbcL8PPT479cVj8DgKsPv1DGZ+43emvyOHJ7vFwPd5NiDeV3JKXFIWh2
         ykBvnkwfJI/PiBxtHacKd+kXpFHqRsXepQXzQ=
Message-ID: <86802c440806121548s71ff31eapc5f389cfa94ea237@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:48:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080612224247.623141000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612224247.486614000@polaris-admin.engr.sgi.com>
	 <20080612224247.623141000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 3:42 PM, Mike Travis <travis@sgi.com> wrote:
>  * Add config option EARLY_SERIAL_CONSOLE to enable early
>   printk's to be directed to the serial console.
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
>          with klogd/syslogd or the X server. You should normally N here,
>          unless you want to debug such a crash.
>
> +config EARLY_SERIAL_CONSOLE
> +       bool "Early Serial Console"
> +       default n
> +       help
> +         Initializes the early console to be the serial port.  The default
> +         is to use the VGA console.
> +
> +         This is useful for server systems that do not have a VGA console.
> +
>  config DEBUG_STACKOVERFLOW
>        bool "Check for stack overflows"
>        depends on DEBUG_KERNEL
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

can you check if it can work with
console=uart8250,io,0x3f8,115200

that is early console, and will switch to normal console automatically

YH

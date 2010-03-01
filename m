Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0CAXFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:05:25 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52334 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0CAXFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:05:24 -0500
Date: Tue, 2 Mar 2010 08:04:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: microblaze-uclinux@itee.uq.edu.au, monstr@monstr.eu,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] microblaze: Support FRAME_POINTER for better backtrace
Message-ID: <20100301230446.GB12088@linux-sh.org>
References: <1267128809-22749-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267128809-22749-1-git-send-email-steve@digidescorp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 02:13:29PM -0600, Steven J. Magnani wrote:
> diff -uprN a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
> --- a/arch/microblaze/Kconfig.debug	2010-02-25 13:52:30.000000000 -0600
> +++ b/arch/microblaze/Kconfig.debug	2010-02-25 13:52:49.000000000 -0600
> @@ -26,4 +26,11 @@ config DEBUG_BOOTMEM
>  	depends on DEBUG_KERNEL
>  	bool "Debug BOOTMEM initialization"
>  
> +config FRAME_POINTER
> +	bool "Use frame pointers"
> +	default n
> +	help
> +	  If you say N here, the resulting kernel will be slightly smaller and
> +	  faster. However, stack dumps will be much harder to interpret.
> +
>  endmenu

This isn't necessary, as it already exists in lib/Kconfig.debug. You can
add your architecture to the list there, or if you want it default
enabled you can also select ARCH_WANT_FRAME_POINTERS.

> diff -uprN a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
> --- a/arch/microblaze/kernel/traps.c	2010-02-25 13:50:00.000000000 -0600
> +++ b/arch/microblaze/kernel/traps.c	2010-02-25 13:51:11.000000000 -0600
> @@ -8,6 +8,7 @@
>   * for more details.
>   */
>  
> +#include <generated/autoconf.h>
>  #include <linux/kernel.h>
>  #include <linux/kallsyms.h>
>  #include <linux/module.h>

No need for this either, it's pulled in by Kbuild.

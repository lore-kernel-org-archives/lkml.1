Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYG2DgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYG2DgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYG2DgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:36:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYG2DgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:36:00 -0400
Date: Mon, 28 Jul 2008 20:33:09 -0700
From: Greg KH <greg@kroah.com>
To: Ben Collins <ben.collins@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] pm: Config option to disable handling of console
	during suspend/resume
Message-ID: <20080729033309.GB12085@kroah.com>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com> <E1KKl4J-00068V-6f@swissweb.swissdisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KKl4J-00068V-6f@swissweb.swissdisk.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 09:48:28PM -0400, Ben Collins wrote:
> Config option allows userspace to handle console during suspend/resume
> instead of the kernel.
> 
> Signed-off-by: Ben Collins <ben.collins@canonical.com>
> ---
>  kernel/power/Kconfig   |   15 +++++++++++++++
>  kernel/power/console.c |    4 ++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index b45da40..6855299 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -105,6 +105,21 @@ config SUSPEND_FREEZER
>  
>  	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
>  
> +config PM_DISABLE_CONSOLE
> +	bool "Disable Power Management messing with the active console"
> +	depends on PM
> +	default n
> +	---help---
> +	  By default, PM will take over the active console (generally, this means
> +	  switching to the console when suspending from X). This can at times cause
> +	  problems, especially if userspace suspend scripts try to do things with
> +	  the console before or after suspending (e.g. calling vbestate).
> +
> +	  To work around this, enable this option so that PM will not handle the
> +	  console.
> +
> +	  If unsure, say N.
> +
>  config HIBERNATION
>  	bool "Hibernation (aka 'suspend to disk')"
>  	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
> diff --git a/kernel/power/console.c b/kernel/power/console.c
> index b8628be..8b9706f 100644
> --- a/kernel/power/console.c
> +++ b/kernel/power/console.c
> @@ -33,6 +33,7 @@ EXPORT_SYMBOL(pm_set_vt_switch);
>  
>  int pm_prepare_console(void)
>  {
> +#ifndef CONFIG_PM_DISABLE_CONSOLE

Can't you do this in a .h file instead?

And is this really needed?  Why has no other distro needed this change?
What is so wierd about your suspend setup to require this?

thanks,

greg k-h

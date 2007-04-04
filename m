Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXDDSnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXDDSnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXDDSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:43:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22825 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbXDDSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:43:05 -0400
Date: Wed, 4 Apr 2007 11:44:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 43/90] ARM: OMAP: TUSB EVM init
Message-Id: <20070404114430.4b9fa9d1.randy.dunlap@oracle.com>
In-Reply-To: <11757100853841-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100302964-git-send-email-tony@atomide.com>
	<1175710033286-git-send-email-tony@atomide.com>
	<117!
 57100403021-git-send-email-tony@atomide.com>
	<11757100423982-git-send-email-tony@atomide.com>
	<117571004562-git-send-email-tony@atomide.com>
	<11757100491583-git-send-email-tony@atomide.com>
	<11757100511172-git-send-email-tony@atomide.com>
	<1175710059333-git-send-email-tony@atomide.com>
	<11757100623383-git-send-email-tony@atomide.com>
	<11757100641006-git-send-email-tony@atomide.com>
	<11757100661228-git-send-email-tony@atomide.com>
	<11757100691131-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:22 -0400 Tony Lindgren wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Add init support for the TUSB6010 EVM board, as connected to H4.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/usb-tusb6010.c |  333 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 333 insertions(+), 0 deletions(-)

...

externs should be in some header file.


> +extern unsigned long gpmc_get_fclk_period(void);
> +
> +/* tusb driver calls this when it changes the chip's clocking */
> +int tusb6010_platform_retime(unsigned is_refclk)
> +{
> +	static const char	error[] =
> +		KERN_ERR "tusb6010 %s retime error %d\n";
> +
> +	unsigned	fclk_ps = gpmc_get_fclk_period();
> +	unsigned	sysclk_ps;
> +	int		status;
> +
> +	if (!refclk_psec)
> +		return -ENODEV;
> +
> +	sysclk_ps = is_refclk ? refclk_psec : TUSB6010_OSCCLK_60;
> +
> +	status = tusb_set_async_mode(sysclk_ps, fclk_ps);
> +	if (status < 0) {
> +		printk(error, "async", status);
> +		goto done;
> +	}
> +	status = tusb_set_sync_mode(sysclk_ps, fclk_ps);
> +	if (status < 0)
> +		printk(error, "sync", status);
> +done:
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(tusb6010_platform_retime);

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

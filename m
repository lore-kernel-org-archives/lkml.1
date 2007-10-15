Return-Path: <linux-kernel-owner+w=401wt.eu-S932947AbXJOSKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbXJOSKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbXJOSJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:09:55 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58496
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbXJOSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:09:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] usb: fix ssb_ohci_probe() build bug
Date: Mon, 15 Oct 2007 20:08:49 +0200
User-Agent: KMail/1.9.6
Cc: Al Viro <viro@ftp.linux.org.uk>, gregkh@suse.de,
       David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
References: <20071014032948.GA25760@elte.hu> <20071015173840.GA26109@elte.hu> <20071015174321.GA27428@elte.hu>
In-Reply-To: <20071015174321.GA27428@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152008.49590.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 19:43:21 Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > find attached another config that reproduces the build failure above.
> > 
> > i think the reason is this:
> > 
> > CONFIG_SSB=m
> > CONFIG_USB_OHCI_HCD=y
> > CONFIG_USB_OHCI_HCD_SSB=y
> 
> the patch below fixes this for me.
> 
> 	Ingo
> 
> ----------------------->
> Subject: usb: fix ssb_ohci_probe() build bug
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix ssb_ohci_probe() build bug:
> 
>  drivers/built-in.o: In function `ssb_ohci_probe':
>  ohci-hcd.c:(.text+0xbff39): undefined reference to `ssb_device_enable'
>  ohci-hcd.c:(.text+0xbff6f): undefined reference to `ssb_admatch_base'
>  ohci-hcd.c:(.text+0xbff8b): undefined reference to `ssb_admatch_size'
>  ohci-hcd.c:(.text+0xbffe5): undefined reference to `ssb_device_disable'
>  [...]
> 
> the reason was that this Kconfig combination was allowed:
> 
>  CONFIG_SSB=m
>  CONFIG_USB_OHCI_HCD=y
>  CONFIG_USB_OHCI_HCD_SSB=y
> 
> the fix is to require a modular USB_OHCI_HCD build when SSB is modular.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Michael Buesch <mb@bu3sch.de>

Somebody of the USB folks apply this, please.

> ---
>  drivers/usb/host/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/usb/host/Kconfig
> ===================================================================
> --- linux.orig/drivers/usb/host/Kconfig
> +++ linux/drivers/usb/host/Kconfig
> @@ -156,7 +156,7 @@ config USB_OHCI_HCD_PCI
>  
>  config USB_OHCI_HCD_SSB
>  	bool "OHCI support for Broadcom SSB OHCI core"
> -	depends on USB_OHCI_HCD && SSB && EXPERIMENTAL
> +	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
>  	default n
>  	---help---
>  	  Support for the Sonics Silicon Backplane (SSB) attached
> 
> 



-- 
Greetings Michael.

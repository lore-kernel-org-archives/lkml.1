Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbZASOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbZASOym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbZASOvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:51:11 -0500
Received: from ports.donpac.ru ([80.254.111.81]:43550 "EHLO ports.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbZASOvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:51:08 -0500
Date: Mon, 19 Jan 2009 17:51:01 +0300
From: Andrey Panin <pazke@donpac.ru>
To: Michael Bramer <michael@debsupport.de>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232 MIC-3620 from advantech'
Message-ID: <20090119145101.GA16732@ports.donpac.ru>
Mail-Followup-To: Michael Bramer <michael@debsupport.de>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <20090118135359.GA3087@deb-support.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118135359.GA3087@deb-support.de>
X-Uname: Linux 2.6.18-4-powerpc64 ppc64
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 018, 01 18, 2009 at 01:53:59PM +0000, Michael Bramer wrote:
> Hello
> 
> This is my first mail to this list... sorry for all my mistakes
> 
> We use a 8-port RS-232 MIC-3620 from advantech (see
> http://www.advantech.com/products/8-port-RS-232-Communication-CPCI-Card/mod_1-2MLG80.aspx)
> and need linux support for this card.
> 
> This patch add is:
> -------------------------------------
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -768,6 +769,8 @@
>  #define PCI_SUBDEVICE_ID_OCTPRO422      0x0208
>  #define PCI_SUBDEVICE_ID_POCTAL232      0x0308
>  #define PCI_SUBDEVICE_ID_POCTAL422      0x0408
> +#define PCI_VENDOR_ID_ADVANTECH         0x13fe
> +#define PCI_DEVICE_ID_ADVANTECH_PCI3620 0x3620
> 
>  /*
>   * Master list of serial port init/setup/exit quirks.
> @@ -789,6 +792,16 @@
>                 .setup          = addidata_apci7800_setup,
>         },
>         /*
> +        * ADVANTECH
> +        */
> +       {
> +               .vendor         = PCI_VENDOR_ID_ADVANTECH,
> +               .device         = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               .subvendor      = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               .subdevice      = PCI_ANY_ID,
> +               .setup          = pci_default_setup,
> +       },
> +       /*
>          * AFAVLAB cards - these may be called via parport_serial
>          *  It is not clear whether this applies to all products.
>          */

This part is not needed at all, pci_default_setup() will be used by default.

> @@ -2041,6 +2054,9 @@
>  #endif
> 
>  static struct pci_device_id serial_pci_tbl[] = {
> +       {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               PCI_DEVICE_ID_ADVANTECH_PCI3620, PCI_ANY_ID, 0, 0,
> +               pbn_b2_8_921600 },
>         {       PCI_VENDOR_ID_V3, PCI_DEVICE_ID_V3_V960,
>                 PCI_SUBVENDOR_ID_CONNECT_TECH,
>                 PCI_SUBDEVICE_ID_CONNECT_TECH_BH8_232, 0, 0,
> -------------------------------------
> 
> can you add this in the next linux kernel?
> 
> Thanks for linux!
> 
> Gruss
> Grisu
> -- 
> Michael Bramer  -- http://www.feuerwehr.kreuzau.de/wiki/
> PGP: finger grisu@db.debian.org  -- Linux Sysadmin   -- Use Debian Linux
> "Wenn ich die Folgen geahnt h?tte, w?re ich Uhrmacher geworden!"
>                                                  --- Albert Einstein
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

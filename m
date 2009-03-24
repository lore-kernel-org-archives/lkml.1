Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZCXPKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZCXPKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZCXPKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:10:41 -0400
Received: from ports.donpac.ru ([80.254.111.81]:58505 "EHLO ports.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZCXPKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:10:41 -0400
Date: Tue, 24 Mar 2009 18:10:34 +0300
From: Andrey Panin <pazke@donpac.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 01/30] disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE
Message-ID: <20090324151034.GC6859@ports.donpac.ru>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
	torvalds@linux-foundation.org
References: <20090324135930.12735.7827.stgit@localhost.localdomain> <20090324140145.12735.29459.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324140145.12735.29459.stgit@localhost.localdomain>
X-Uname: Linux 2.6.18-4-powerpc64 ppc64
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 083, 03 24, 2009 at 02:01:52PM +0000, Alan Cox wrote:
> From: Clark Williams <williams@redhat.com>
> 
> There are known (but hard to fix issues) with using SERIAL_8250_PNP with
> SERIAL_8250_CONSOLE. This patch just sidesteps that by not allowing PNP
> when CONSOLE is selected.

This patch looks very controversial from my POV. Now distro people must decide
what to enable SERIAL_8250_PNP or SERIAL_8250_CONSOLE. And no matter what you 
choose you'll get a regression, non-working serial console vs broken detection of
perfectly working hardware like additional serial ports on industrial computers,
notebook touchpads and finally old and dusty ISA PnP modems.

How widespread are these "known but hard to fix issues", to justify such drastic
change ?

> Signed-off-by: Clark Williams <williams@redhat.com>
> Signed-off-by: Alan Cox <number6@the-village.bc.nu>
> ---
> 
>  drivers/serial/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 7d7f576..451b64f 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -91,7 +91,7 @@ config SERIAL_8250_PCI
>  
>  config SERIAL_8250_PNP
>  	tristate "8250/16550 PNP device support" if EMBEDDED
> -	depends on SERIAL_8250 && PNP
> +	depends on SERIAL_8250 && PNP && ! SERIAL_8250_CONSOLE
>  	default SERIAL_8250
>  	help
>  	  This builds standard PNP serial support. You may be able to
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

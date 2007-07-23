Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbXGWLyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbXGWLyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbXGWLyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:54:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41966 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbXGWLyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:54:06 -0400
Date: Mon, 23 Jul 2007 13:53:30 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb/atm: fix Kconfig garbage
Message-ID: <20070723115329.GH26212@stusta.de>
References: <20070723065604.GA8525@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070723065604.GA8525@gollum.tnic>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 08:56:04AM +0200, Borislav Petkov wrote:
> Hi there,
> 
> I don't know whether this is the proper Kconfig-way to fix this but it works ok here.
> 
> ----
> When entered, the menu point "USB DSL modem support" in menuconfig, path [Device Drivers->USB
> Support] shows no entries but "^@" instead. The following fixes it.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> --
> --- linux-2.6.23-rc1/drivers/usb/atm/Kconfig.orig	2007-07-23 08:27:29.000000000 +0200
> +++ linux-2.6.23-rc1/drivers/usb/atm/Kconfig	2007-07-23 08:50:55.000000000 +0200
> @@ -7,7 +7,8 @@ menu "USB DSL modem support"
>  
>  config USB_ATM
>  	tristate "USB DSL modem support"
> -	depends on USB && ATM
> +	depends on USB
> +	select ATM
>  	select CRC32
>  	default n
>  	help

This would break the compilation with CONFIG_NET=n.

> Regards/Gruß,
>     Boris.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


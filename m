Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZKBTAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZKBTAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbZKBTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:00:10 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45513 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbZKBTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:00:08 -0500
Date: Mon, 2 Nov 2009 13:48:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: linux-next: Tree for November 2 (wireless/wl1271)
Message-ID: <20091102184843.GK14046@tuxdriver.com>
References: <20091102173845.210d1c57.sfr@canb.auug.org.au> <4AEF1E7F.50306@oracle.com> <20091102184449.GJ14046@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102184449.GJ14046@tuxdriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helps if I actually Cc: Luca...

On Mon, Nov 02, 2009 at 01:44:49PM -0500, John W. Linville wrote:
> On Mon, Nov 02, 2009 at 10:01:35AM -0800, Randy Dunlap wrote:
> > Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20091030:
> > 
> > 
> > wl1271 build fails when CONFIG_INET=n.
> > Should this driver depend on INET?
> > 
> > Why does this driver, unlike all other wireless drivers,
> > want to use register_inetaddr_notifier()?
> > 
> > wl1271_main.c:(.text+0x271052): undefined reference to `unregister_inetaddr_notifier'
> > wl1271_main.c:(.text+0x2714d7): undefined reference to `register_inetaddr_notifier'
> 
> Yeah, that driver is doing some filtering based on IPv4.
> 
> Luca, is that necessary?  If so, then we need a patch like the one below...?
> 
> John
> 
> From ba823accfad68151d80503ff5fb04c049c9eadc2 Mon Sep 17 00:00:00 2001
> From: John W. Linville <linville@tuxdriver.com>
> Date: Mon, 2 Nov 2009 13:43:32 -0500
> Subject: [PATCH] wl1271: depend on INET
> 
> wl1271_main.c:(.text+0x271052): undefined reference to `unregister_inetaddr_notifier'
> wl1271_main.c:(.text+0x2714d7): undefined reference to `register_inetaddr_notifier'
> 
> Driver is doing some filtering based on IP addresses...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/wl12xx/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
> index 33de7fa..785e024 100644
> --- a/drivers/net/wireless/wl12xx/Kconfig
> +++ b/drivers/net/wireless/wl12xx/Kconfig
> @@ -42,6 +42,7 @@ config WL1251_SDIO
>  config WL1271
>  	tristate "TI wl1271 support"
>  	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
> +	depends on INET
>  	select FW_LOADER
>  	select CRC7
>  	---help---
> -- 
> 1.6.2.5
> 
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

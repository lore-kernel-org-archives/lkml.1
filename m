Return-Path: <linux-kernel-owner+w=401wt.eu-S965267AbXFGT2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbXFGT2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964852AbXFGT1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:27:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56585 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964838AbXFGT1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:27:51 -0400
Date: Thu, 7 Jun 2007 21:27:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607192754.GP5500@stusta.de>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <200706062132.37430.m.kozlowski@tuxland.pl> <20070606132439.3f59f0cf.akpm@linux-foundation.org> <20070606212831.GA1534@gondor.apana.org.au> <20070606164202.a3dcd176.akpm@linux-foundation.org> <Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 08:54:50AM +0200, Jan Engelhardt wrote:
> 
> On Jun 6 2007 16:42, Andrew Morton wrote:
> 
> >> If so then you sent to it me :)
> >
> >You merged it ;)
> >
> >> Should I drop it?
> >
> >Sure, Jan will fix it up, I assume.  I might have broken it while repairing
> >the reject storm which occurred when that durned HAS_IOMEM thing went in
> >all over the tree.
> 
> /me points at Herbert
> Andrew would not add options between the "menuconfig CRYPTO" and
> the "if CRYPTO" line... :)
> 
> 
> 	Jan
> 
> 
> ===
> 
> Unbreak the crypto menu breakage.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  crypto/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22-rc4/crypto/Kconfig
> ===================================================================
> --- linux-2.6.22-rc4.orig/crypto/Kconfig
> +++ linux-2.6.22-rc4/crypto/Kconfig
> @@ -7,6 +7,8 @@ menuconfig CRYPTO
>  	help
>  	  This option provides the core Cryptographic API.
>  
> +if CRYPTO
> +
>  #
>  # Generic algorithms support
>  #
> @@ -18,8 +20,6 @@ config XOR_BLOCKS
>  #
>  source "crypto/async_tx/Kconfig"
>  
> -if CRYPTO
> -
>  config CRYPTO_ALGAPI
>  	tristate
>  	help

This seems to be buggy since the options in crypto/async_tx/Kconfig do 
not depend on the crypto subsystem (and they are not user visible 
options that get select'ed).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


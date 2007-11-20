Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbXKTOxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbXKTOxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbXKTOw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:52:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:55586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbXKTOw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:52:56 -0500
Subject: Re: [Fwd: MMC sub-system: SDIO block-mode with increment address
	issue]
From: Dean Jenkins <djenkins@mvista.co.uk>
Reply-To: djenkins@mvista.co.uk
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071120115104.163810ea@poseidon.drzeus.cx>
References: <1195554533.18869.111.camel@libdev3.libertesoft.co.uk>
	 <20071120115104.163810ea@poseidon.drzeus.cx>
Content-Type: text/plain
Organization: MontaVista
Date: Tue, 20 Nov 2007 14:52:37 +0000
Message-Id: <1195570357.13874.17.camel@libdev3.libertesoft.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+8d06tWgp5zGz/n1cHJ52CdIVe86nElSFEkpD
 nawXl0NixWn8/H7WyceYgAJ5V1gcJV5S3Se/5GfG/me2iugV2O
 z3hZIKf1wqWjUrkF+X81Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

My card driver needed to set the R/W E4MI bit in the Card Capability
register (0x08) in CCCR (function 0). Perhaps it is unnecessary ?

BTW. It is easy to for the card driver to access function 0 registers by
doing the following...

...
	int old_num = func->num;   /* note the current function number */

	/* force access to function 0 area */
	func->num = 0;

	/* enable the e4mi in the card capability register */
	x = sdio_readb(func, 0x000008, &ret);

	if ( ret == 0 ) {
		x |= 0x20;
		sdio_writeb(func, x, 0x000008, &ret);
	}

	/* restore to original function number */
	func->num = old_num; 

...

Regards,
Dean.


On Tue, 2007-11-20 at 11:51 +0100, Pierre Ossman wrote:
> On Tue, 20 Nov 2007 10:28:53 +0000
> Dean Jenkins <djenkins@...> wrote:
> 
> > Hi Pierre,
> > 
> > I've managed to find your E-mail address in the Linux kernel mailing
> > list. I hope it is OK to directly E-mail you ?
> > 
> 
> You should also find my address in the MAINTAINERS file, which is where you should look for contact info. But yes, you can contact me directly. I prefer that you also add a relevant mailing list though.
> 
> > I work for MontaVista Software in the UK. I guess you know that
> > MontaVista are using the MMC/SDIO sub-system in their latest Mobilinux
> > 5.0 product ? It is using a 2.6.21 kernel.
> > 
> > Yesterday, I sent an E-mail to you (attached) to the Linux kernel
> > mailing list. Do you have any comments to make ?
> > 
> 
> Didn't notice it. I'll have a look.
> 
> > Do you have any bug reporting facility for the MMC/SDIO sub-system ? I
> > would like to report some SDIO API limitations for the SDIO card drivers
> > that I needed to workaround. For example, my SDIO driver needs to modify
> > the contents of the Card Capability register in function 0 to enable
> > block-mode support but the card driver has been restricted to only be
> > able to use function 1. There are other registers as well that the card
> > driver needs access to.
> > 
> 
> That is by design (as you probably can tell). Letting function drivers touch card global stuff under the feet of the SDIO core is a big layering violation and bound to screw things up eventually.
> 
> Could you explain more in detail what it is you need to fiddle with in function 0 and why?
> 
> Rgds
-- 
Dean Jenkins
Embedded Software Engineer
MontaVista Software (UK)
Professional Services Division


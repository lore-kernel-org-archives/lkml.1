Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZHXNHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZHXNHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 09:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZHXNHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 09:07:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50485 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZHXNHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:07:21 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+2Y+tGTpGgFCEJ/cDGUHc2
Date: Mon, 24 Aug 2009 16:07:18 +0300
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Syed Rafiuddin <rafiuddin.syed@ti.com>,
       Russell King <rmk@arm.linux.org.uk>, Kalle Valo <kalle.valo@iki.fi>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
Message-ID: <20090824130718.GC5165@atomide.com>
References: <20090819150433.4c12c612.sfr@canb.auug.org.au> <20090820102004.GD12309@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820102004.GD12309@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [090820 14:20]:
> * Stephen Rothwell <sfr@canb.auug.org.au> [090819 08:04]:
> > Hi all,
> > 
> > Today's linux-next merge of the omap tree got a conflict in
> > arch/arm/mach-omap2/board-4430sdp.c between commit
> > 085b54d99b8ee999e7905b8f16e201e0da8ba369 ("ARM: OMAP4: Add UART4
> > support") from the arm tree and commit
> > 4c29fa3e47342666e12e46f35f40dd90b12cd1a4 ("OMAP: remove OMAP_TAG_UART")
> > from the omap tree.
> > 
> > Just context changes (I think).  I fixed it up (see below) and can carry
> > the fix as necessary.
> 
> Thanks yeh the fix looks right. I'll take a look if I can squeeze something
> like that into my queue so the merge conflict disappears.

The merge conflict should be gone now, Kevin realized we don't need the
platform_data any longer. Will remove that for board-4430sdp.c and serial.h
as a fix once the other pending changes have been merged.
 
> Regards,
> 
> Tony
> 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc arch/arm/mach-omap2/board-4430sdp.c
> > index 1b22307,646079f..0000000
> > --- a/arch/arm/mach-omap2/board-4430sdp.c
> > +++ b/arch/arm/mach-omap2/board-4430sdp.c
> > @@@ -38,8 -38,8 +38,8 @@@ static struct platform_device *sdp4430_
> >   	&sdp4430_lcd_device,
> >   };
> >   
> > - static struct omap_uart_config sdp4430_uart_config __initdata = {
> > + static struct omap_uart_platform_data sdp4430_uart_config __initdata = {
> >  -	.enabled_uarts	= (1 << 0) | (1 << 1) | (1 << 2),
> >  +	.enabled_uarts	= (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3),
> >   };
> >   
> >   static struct omap_lcd_config sdp4430_lcd_config __initdata = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

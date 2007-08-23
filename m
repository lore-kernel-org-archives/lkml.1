Return-Path: <linux-kernel-owner+w=401wt.eu-S1764602AbXHWRmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764602AbXHWRmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764923AbXHWRmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:42:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:16734 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763235AbXHWRmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=cMY7WPp+uAoT0JKiGr4ssUu9HbntodfEbu3fyWl5akO8LaPDG0+4V9u5zb01ULLRhpittsQuTmWiWhWr1dwnwpGcisfnHezlvaCtq4oFzD/hcuV9T/Xqew280JTs/LYfCey5ATC05g9+uPMcNYpYdkr18e4M3a/nSDg4UgQEosg=
Date: Thu, 23 Aug 2007 21:42:04 +0400
To: Brandon Philips <brandon@ifup.org>
Cc: postfail@hushmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH resubmit] /drivers/ata ioremap returncode check
Message-ID: <20070823174204.GB1818@martell.zuzino.mipt.ru>
References: <20070823023328.19E6CDA82B@mailserver7.hushmail.com> <159327.52462.qm@web44910.mail.sp1.yahoo.com> <20070823053458.GA4418@ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823053458.GA4418@ifup.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:34:58PM -0700, Brandon Philips wrote:
> On 19:47 Wed 22 Aug 2007, Scott Thompson wrote:
> > Patchset against 2.6.23-rc3.  corrects missing ioremap return 
> > checks, resending after making changes suggested....
> > 
> > Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
> > ------------------------------------------------------------
> > diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
> > index 4ca7fd6..8dc7c3b 100644
> > --- a/drivers/ata/pata_ixp4xx_cf.c
> > +++ b/drivers/ata/pata_ixp4xx_cf.c
> > @@ -189,6 +189,10 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
> >  	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
> >  	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
> >  
> > +	if (!data->cs0 || !data->cs1) {
> > +		return -ENOMEM;
> > +	}
> > +
> 
> You aren't following the Kernel CodingStyle there.  
> 
> See Documentation/CodingStyle:
> 
> "Do not unnecessarily use braces where a single statement will do."
> 
> +	if (!data->cs0 || !data->cs1)
> +		return -ENOMEM;

This and nice printk message absence. :)

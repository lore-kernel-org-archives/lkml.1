Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbXJRGHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbXJRGHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXJRGG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:06:56 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:4868 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXJRGGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:06:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=krNEEWUR/XNcHpAo/3PG7XvXCef9nZkU4zPki707WDt9jXced2vKYbsuc9Kv0UuxZZbGnRkz5yBCPTQB1pdzRtmYXAq42M/WVqcFpYmCpY4YjYEB9prlxVPOOT8s5Qna4zth5Aem2+N5enaeDu7tDpwC3Pp0W9KCbRD2XAt0+uA=
Message-ID: <386072610710172306m2a0831eds646da3d7c78809bb@mail.gmail.com>
Date: Thu, 18 Oct 2007 14:06:53 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 02/10] Blackfin SPI driver: use new GPIO API and add error handling
Cc: bryan.wu@analog.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <200710121017.47645.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
	 <200710112326.34500.david-b@pacbell.net>
	 <1192172077.6247.15.camel@roc-laptop>
	 <200710121017.47645.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 11 October 2007, Bryan Wu wrote:
> > On Thu, 2007-10-11 at 23:26 -0700, David Brownell wrote:
> > > On Thursday 11 October 2007, Bryan Wu wrote:
> > > > @@ -1182,12 +1198,9 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
> > > >                 return -ENOMEM;
> > > >         }
> > > >
> > > > -       if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
> > > > -                peripheral_request(P_SPI0_MISO, DRV_NAME) ||
> > > > -                peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
> > > > -
> > > > +       if (setup_pin_mux(1)) {
> > > >                 dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
> > > > -               goto out_error_queue_alloc;
> > > > +               goto out_error;
> > > >         }
> > > >
> > > >         drv_data = spi_master_get_devdata(master);
> > > >
> > >
> > > Still doesn't apply ... what tree are you generating this series against??
> >
> > I apply this patch on Linus git tree at 2.6.23 tag
>
> Then why don't my copies of that tree have the lines flagged
> above with "-" ??
>
> In fact, if I look at the kernel.org GIT tree, it doesn't have
> them either.  Your tree must have somehow gotten a bunch of
> private changes.
>

Did you apply these patches, or I need resent a new patchset against
latest Linus GIT tree?
I noticed in latest GIT tree the Blackfin SPI driver are modified.

Thanks
-Bryan Wu

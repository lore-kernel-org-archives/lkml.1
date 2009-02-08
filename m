Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZBHQ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZBHQ3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZBHQ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:28:51 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:47813 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751500AbZBHQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:28:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O04Ld/g2htxy0s/SxXLOkmocv6ULvqFo2O9mH1a7vKeCFdZ0wtjKp9ong78cC8pORwbGkRgpvxINcqM/kbotPClgKRn6SF2MRvU62E9O5FYE/oeyadDq6NOXXyKTXkF7NSxAxv5W4uCRNGBD/3ELua8Wm2X7j7mAMxY5axSBCXs=  ;
X-YMail-OSG: f5yqN_IVM1nJc8CcPEnzSdgNcf1Cj.qmx8_9lQSkOtGrasPcFZ1_I21lvbq4JSDl7RD3TpuO7v0YbQXAW1RCwvmK.T19xf.YxbfRL.cQtKahakrjFsD8C0s5M1MuX_vmSEaP_VCDCOLcty4xzg6WysRGp4KAUFLgzJNz4lxA1JDA9vCpHL3Jkt8l2krohNgm4w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] spi: limit reaches -1, tested 0
Date: Sun, 8 Feb 2009 08:28:48 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <498EE9C0.3010601@gmail.com> <200902080755.26241.david-b@pacbell.net>
In-Reply-To: <200902080755.26241.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902080828.49036.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, David Brownell wrote:
> On Sunday 08 February 2009, Roel Kluin wrote:
> > With a postfix decrement limit will reach -1 rather than 0,
> > so the warning will not be issued.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> 
> 
> > ---
> > diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
> > index 269a55e..a4652f1 100644
> > --- a/drivers/spi/spi_imx.c
> > +++ b/drivers/spi/spi_imx.c
> > @@ -779,7 +779,7 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
> >  
> >  			/* Read trailing bytes */
> >  			limit = loops_per_jiffy << 1;
> > -			while ((read(drv_data) == 0) && limit--);
> > +			while ((read(drv_data) == 0) && --limit);

... although I wouldn't have resisted the urge to make the
loop body be "cpu_relax();" instead of an empty statement.


> >  
> >  			if (limit == 0)
> >  				dev_err(&drv_data->pdev->dev,
> > 
> > 
> 
> 
> 



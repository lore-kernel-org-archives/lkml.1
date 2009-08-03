Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZHCPvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZHCPvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZHCPvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:51:24 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:52954 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZHCPvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:51:23 -0400
Date: Mon, 3 Aug 2009 17:50:49 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@maxim.org.za, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Switch atmel_serial to dev_pm_ops
Message-ID: <20090803155049.GD5002@laptop>
References: <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com>
 <20090803170947.2f199b93@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803170947.2f199b93@hskinnemoen-d830>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:09:47PM +0200, Haavard Skinnemoen wrote :
> Albin Tonnerre wrote:
> > +static struct dev_pm_ops atmel_serial_pm_ops = {
> > +	.suspend = atmel_serial_suspend,
> > +	.resume = atmel_serial_resume,
> > +};
> >  #else
> > -#define atmel_serial_suspend NULL
> > -#define atmel_serial_resume NULL
> > +static struct dev_pm_ops atmel_serial_pm_ops;

> Why not

> #define atmel_serial_pm_ops	NULL

Because the .pm field is set to the address of atmel_serial_pm_ops, and iirc
taking the address of NULL is not allowed.

> >  #endif

> >  static int __devinit atmel_serial_probe(struct platform_device *pdev)
> > @@ -1603,11 +1607,10 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
> >  static struct platform_driver atmel_serial_driver = {
> >  	.probe		= atmel_serial_probe,
> >  	.remove		= __devexit_p(atmel_serial_remove),
> > -	.suspend	= atmel_serial_suspend,
> > -	.resume		= atmel_serial_resume,
> >  	.driver		= {
> >  		.name	= "atmel_usart",
> >  		.owner	= THIS_MODULE,
> > +		.pm = &atmel_serial_pm_ops,

> Please use a TAB instead of space to make everything nice and
> consistent.

That's weird, because my editor does show a TAB there, and applying the patch
with git am results in a TAB.

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com

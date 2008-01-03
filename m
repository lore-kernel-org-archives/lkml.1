Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbYACNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbYACNsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYACNsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:48:38 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49626 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYACNsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:48:37 -0500
Date: Thu, 3 Jan 2008 15:48:35 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: Add GPIO w1 bus master driver
Message-ID: <20080103134835.GM15861@sci.fi>
References: <1198222441690-git-send-email-syrjala@sci.fi> <20071226232454.039372b8@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071226232454.039372b8@siona>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 11:24:54PM +0100, Haavard Skinnemoen wrote:
> On Fri, 21 Dec 2007 09:34:01 +0200
> Ville Syrjala <syrjala@sci.fi> wrote:
> 
> > +static struct platform_device foo_w1_device = {
> > +	.name			= "w1-gpio",
> > +	.id			= -1,
> 
> Assigning -1 to a u32 member isn't a very nice example. What does it
> mean anyway?

id is 'int'. The bus_name won't include the id when -1 is used.

> > +static int __init w1_gpio_probe(struct platform_device *pdev)
> 
> This must be __devinit, or if you want to save a bit of memory...
> 
> > +	.probe	= w1_gpio_probe,
> 
> ...remove this line, and...
> 
> > +static int __init w1_gpio_init(void)
> > +{
> > +	return platform_driver_register(&w1_gpio_driver);
> 
> ...call platform_driver_probe(&w1_gpio_driver, w1_gpio_probe) here.

I was wondering what platform_driver_probe() was for but never bothered
to read the code. I'll change the code to use it.

I already sent an updated patch but forgot to send this reply.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbXLUMmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbXLUMmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLUMmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:42:16 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48069 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbXLUMmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:42:15 -0500
Date: Fri, 21 Dec 2007 14:42:13 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: Add GPIO w1 bus master driver
Message-ID: <20071221124213.GG15861@sci.fi>
References: <1198222441690-git-send-email-syrjala@sci.fi> <20071221104127.GA28474@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071221104127.GA28474@2ka.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 01:41:28PM +0300, Evgeniy Polyakov wrote:
> Hi Ville.
> 
> On Fri, Dec 21, 2007 at 09:34:01AM +0200, Ville Syrjala (syrjala@sci.fi) wrote:
> > Add a GPIO 1-wire bus master driver. The driver used the GPIO API to
> > control the wire and the GPIO pin can be specified using platform data
> > similar to i2c-gpio. The driver was tested with AT91SAM9260 + DS2401.
> 
> This looks ok, only a minor nit about codying style below.
> 
> > Signed-off-by: Ville Syrjala <syrjala@sci.fi>
> 
> ACK.
> 
> > +static int __init w1_gpio_probe(struct platform_device *pdev)
> > +{
> > +	struct w1_bus_master *master;
> > +	struct w1_gpio_platform_data *pdata;
> > +	int err;
> > +
> > +	pdata = pdev->dev.platform_data;
> > +	if (!pdata)
> > +		return -ENXIO;
> > +
> > +	master = kzalloc(sizeof *master, GFP_KERNEL);
> > +	if (!master)
> > +		return -ENOMEM;
> 
> I think sizeof(struct w1_bus_master) is a better way.

Will change.

> > new file mode 100644
> > index 0000000..3b80bb2
> > --- /dev/null
> > +++ b/include/linux/w1-gpio.h
> 
> Does anyone use this file except driver itself?

It's supposed to be used by the code that registers the platform device
(see the example in the documentation). No in-tree users since the board
I'm using is not supported by the kernel.

I just had a better look at i2c-gpio and noticed that I missed
gpio_request()/gpio_free() calls from the driver. Also the open-drain
requirement could be removed like i2c-gpio does. I'll send a new patch
ASAP.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbZDQTK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbZDQTK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZDQTHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:56724 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756112AbZDQTHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:36 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+K7EA9TVKKJA0dt2VH4aNyegWjg6aFfleKKp5Uta
	PElzbzVM7FCzSh
Date: Fri, 17 Apr 2009 21:07:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Florian Fainelli <florian@openwrt.org>
cc: Peter Holik <peter@holik.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
In-Reply-To: <200904171632.26091.florian@openwrt.org>
Message-ID: <Pine.LNX.4.64.0904172102300.5119@axis700.grange>
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
 <200904171632.26091.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Florian Fainelli wrote:

> > diff --git a/drivers/net/usb/intellon.c b/drivers/net/usb/intellon.c
> > new file mode 100644
> > index 0000000..c9fcc38
> > --- /dev/null
> > +++ b/drivers/net/usb/intellon.c
> > @@ -0,0 +1,273 @@
> > +/*
> > + * Copyright (c) 2009 Peter Holik
> > + *
> > + * Intellon PLC (Powerline Communications) usb net driver
> 
> Intellon INT51x1 PLC ...
> [snip]
> 
> > +
> > +static u8 nibble(unsigned char c)
> > +{
> > +	if (likely(isdigit(c)))
> > +		return c - '0';
> > +	c = toupper(c);
> > +	if (likely(isxdigit(c)))
> > +		return 10 + c - 'A';
> > +	return 0;
> > +}
> 
> Please prefix this with intellon_ (or int51x1_) for instance to avoid any 
> possible namespace clash.
> 
> > +
> > +static inline int get_ethernet_addr(struct usbnet *dev)
> > +{
> > +	int             tmp, i;
> > +	unsigned char   buf [13];
> > +
> > +	tmp = usb_string(dev->udev, 3, buf, sizeof buf);
> > +	if (tmp != 12) {
> > +		devdbg(dev, "bad MAC string fetch, %d\n", tmp);
> > +		if (tmp >= 0)
> > +			tmp = -EINVAL;
> > +		return tmp;
> > +	}
> > +	for (i = tmp = 0; i < 6; i++, tmp += 2)
> > +		dev->net->dev_addr [i] =
> > +			(nibble(buf [tmp]) << 4) + nibble(buf [tmp + 1]);
> > +	return 0;
> > +}
> 
> Same here.

FWIW, I think it's pretty common to name static functions in a .c file, 
which perform auxiliary function, not really specific to the context 
without the respective context-prefix. Of course, it might indeed happen 
that a global symbol "nibble" or "get_ethernet_addr" gets introduced at 
some point thus leading to a conflict, but this seems to be unlikely. And 
in any case the one who introduces such a symbol will have to grep the 
entire kernel anyway.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

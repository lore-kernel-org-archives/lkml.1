Return-Path: <linux-kernel-owner+w=401wt.eu-S932120AbXBNBG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbXBNBG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbXBNBG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:06:27 -0500
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:48568 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932120AbXBNBG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:06:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Q6VQuPtZ3STxtTAUzvfd2d8ihKtcnLdhPgH07c3CZhzJP58w60pw3frbiTn11XSPOzGUYrFYCmG0yYdComKzYHfuO0tv14xqZVINEw7o0TJGmAO52etRPVZz/1/Yv6YMKthYzSfTKVWhcbdYPY0ipAQJpk6LuratHQRlSRD8qZ4=  ;
X-YMail-OSG: Izl1UiYVM1mLaE7yhMm6jQ2sE00K1c6os6xeRej8r8Yf_xBJNb6HURZjxO5Pbj8D1eOTh8kGKUGFUS91gt5EXYBeZZPtecqcSSTro.YHd2dw9Z2UvjSd.SEXyUI4dWjIBXxcveq5y6Z5xg--
Date: Tue, 13 Feb 2007 17:06:23 -0800
From: David Brownell <david-b@pacbell.net>
To: randy.dunlap@oracle.com, linux-usb-devel@lists.sourceforge.net,
       cebbert@redhat.com
Subject: Re: [linux-usb-devel] Is this bug too obvious?
Cc: linux-kernel@vger.kernel.org, davej@redhat.com
References: <45D25ABE.5080400@redhat.com>
 <20070213164946.f70d1c8e.randy.dunlap@oracle.com>
In-Reply-To: <20070213164946.f70d1c8e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070214010623.E0FA7218500@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No bug; read net/ethernet/eth.c to see what that parameter means.

> > drivers/usb/net/usbnet.c:
> > 
> > int
> > usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
> > {
> >         struct usbnet                   *dev;
> >         struct net_device               *net;
> >         struct usb_host_interface       *interface;
> >         struct driver_info              *info;
> >         struct usb_device               *xdev;
> >         int                             status;
> > 
> > 	...
> > 
> >         net = alloc_etherdev(sizeof(*dev));
> >                                     ^^^^
> > 	                            *net ???

It's allocating *extra* space ... used just a few lines later:

        dev = netdev_priv(net);


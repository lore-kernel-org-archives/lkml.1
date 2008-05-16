Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYEPRb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYEPRb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759290AbYEPRa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:30:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35043 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257AbYEPRa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:30:57 -0400
Date: Fri, 16 May 2008 09:53:51 -0700
From: Greg KH <greg@kroah.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: akirat@rd.scei.sony.co.jp, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-serial: pl2303: add support for RATOC REX-USB60F
Message-ID: <20080516165351.GD24977@kroah.com>
References: <20080118185231.0B48.4D252088@rd.scei.sony.co.jp> <20080516.171345.01918000.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516.171345.01918000.nemoto@toshiba-tops.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 05:13:45PM +0900, Atsushi Nemoto wrote:
> # Sorry, resend with new linux-usb ML address.
> 
> On Fri, 18 Jan 2008 18:58:28 +0900, Akira Tsukamoto <akirat@rd.scei.sony.co.jp> wrote:
> > pl2303: add support for RATOC REX-USB60F
> > 
> > This patch adds support for RATOC REX-USB60F Serial Adapters,
> > which is widely used in Japan recently.
> > 
> > Signed-off-by: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
> > ---
> > 
> > diff -uprX dontdiff linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.c linux-2.6.24-rc8/drivers/usb/serial/pl2303.c
> > --- linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.c	2008-01-18 18:11:51.000000000 +0900
> > +++ linux-2.6.24-rc8/drivers/usb/serial/pl2303.c	2008-01-18 18:43:28.000000000 +0900
> > @@ -65,6 +65,7 @@ static struct usb_device_id id_table [] 
> >  	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID_2080) },
> >  	{ USB_DEVICE(MA620_VENDOR_ID, MA620_PRODUCT_ID) },
> >  	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID) },
> > + 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
> >  	{ USB_DEVICE(TRIPP_VENDOR_ID, TRIPP_PRODUCT_ID) },
> >  	{ USB_DEVICE(RADIOSHACK_VENDOR_ID, RADIOSHACK_PRODUCT_ID) },
> >  	{ USB_DEVICE(DCU10_VENDOR_ID, DCU10_PRODUCT_ID) },
> 
> Hi.  I tried RATOC REX-USB60F with pl2303 driver and got oops in
> pl2303_open().  The pl2303 expects a interrupt_in endpoint but my
> device does not have interrupt_in.  So this line in pl2303_open()
> cause oops.
> 
> 	port->interrupt_in_urb->dev = serial->dev;
> 
> This device works fine with the ftdi_sio driver, with "vendor=0x584
> product=0xb020" module option.  (0x584 is RATOC_VENDOR_ID and 0xb020
> is RATOC_PRODUCT_ID_USB60F).

Ick, thanks for letting me know.

> Is the pl2303 driver appropriate for this device?

Based on your lsusb output, no, I think it is the ftdi_sio one.  I'll go
apply your patch.

thanks again,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZAVUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZAVUNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZAVUNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:13:34 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:28964 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbZAVUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:13:33 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAJRieElR9SBg/2dsb2JhbACBbcoRhXM
Date: Thu, 22 Jan 2009 21:13:30 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Julia Lawall <julia@diku.dk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/watchdog: use USB API functions rather than constants
Message-ID: <20090122201330.GA4501@infomag.infomag.iguana.be>
References: <Pine.LNX.4.64.0812291123240.9555@pc-004.diku.dk> <20090104181923.GY11454@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104181923.GY11454@infomag.infomag.iguana.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

> > diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
> > index afb0896..b5320a8 100644
> > --- a/drivers/watchdog/pcwd_usb.c
> > +++ b/drivers/watchdog/pcwd_usb.c
> > @@ -609,9 +609,7 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
> >  	/* check out the endpoint: it has to be Interrupt & IN */
> >  	endpoint = &iface_desc->endpoint[0].desc;
> >  
> > -	if (!((endpoint->bEndpointAddress & USB_DIR_IN) &&
> > -	     ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> > -				== USB_ENDPOINT_XFER_INT))) {
> > +	if (!usb_endpoint_is_int_in(endpoint)) {
> >  		/* we didn't find a Interrupt endpoint with direction IN */
> >  		printk(KERN_ERR PFX "Couldn't find an INTR & IN endpoint\n");
> >  		return -ENODEV;
> 
> Seems OK. I will test it this week and let you know.

Tested OK.

Will I add this into the watchdog-tree so that it can go mainline?

Kind regards,
Wim.


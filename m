Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZGAOeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZGAOeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZGAOeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:34:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37640 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750894AbZGAOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:34:01 -0400
Date: Wed, 1 Jul 2009 10:34:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arseniy Lartsev <ars3n@yandex.ru>
cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [PATCH] cdc-acm: work around some broken devices
In-Reply-To: <200907011627.31170.ars3n@yandex.ru>
Message-ID: <Pine.LNX.4.44L0.0907011030130.3066-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Arseniy Lartsev wrote:

> On Wednesday 01 July 2009 15:37:48 Oliver Neukum wrote:
> > Yes, exactly. Please add greg@kroah.com into CC, add a Signed-off-by line
> > and resend.
> ok
> 
> Signed-off-by: Arseniy Lartsev <ars3n at yandex dot ru>
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -387,6 +387,7 @@ static void acm_rx_tasklet(unsigned long
>  	struct acm_ru *rcv;
>  	unsigned long flags;
>  	unsigned char throttled;
> +	struct usb_host_endpoint *ep;
>  
>  	dbg("Entering acm_rx_tasklet");
>  
> @@ -462,11 +463,20 @@ urbs:
>  
>  		rcv->buffer = buf;
>  
> -		usb_fill_bulk_urb(rcv->urb, acm->dev,
> -				  acm->rx_endpoint,
> -				  buf->base,
> -				  acm->readsize,
> -				  acm_read_bulk, rcv);
> +		ep = (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in : acm->dev->ep_out)
> +				[usb_pipeendpoint(acm->rx_endpoint)];

Isn't acm->rx_endpoint always going to be IN?

Alan Stern


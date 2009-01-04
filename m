Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZADSTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZADSTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZADST1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:19:27 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:57111 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbZADST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:19:27 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFAJ6MYElR9cRP/2dsb2JhbACBbMcYhXI
Date: Sun, 4 Jan 2009 19:19:23 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Julia Lawall <julia@diku.dk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/watchdog: use USB API functions rather than constants
Message-ID: <20090104181923.GY11454@infomag.infomag.iguana.be>
References: <Pine.LNX.4.64.0812291123240.9555@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812291123240.9555@pc-004.diku.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

> diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
> index afb0896..b5320a8 100644
> --- a/drivers/watchdog/pcwd_usb.c
> +++ b/drivers/watchdog/pcwd_usb.c
> @@ -609,9 +609,7 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
>  	/* check out the endpoint: it has to be Interrupt & IN */
>  	endpoint = &iface_desc->endpoint[0].desc;
>  
> -	if (!((endpoint->bEndpointAddress & USB_DIR_IN) &&
> -	     ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -				== USB_ENDPOINT_XFER_INT))) {
> +	if (!usb_endpoint_is_int_in(endpoint)) {
>  		/* we didn't find a Interrupt endpoint with direction IN */
>  		printk(KERN_ERR PFX "Couldn't find an INTR & IN endpoint\n");
>  		return -ENODEV;

Seems OK. I will test it this week and let you know.

Kind regards,
Wim.


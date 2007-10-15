Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXJOMA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXJOMA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbXJOMAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:00:17 -0400
Received: from probity.mcc.ac.uk ([130.88.200.94]:51131 "EHLO
	probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849AbXJOMAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:00:15 -0400
X-Greylist: delayed 3269 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 08:00:15 EDT
Message-ID: <4713498E.8040305@gentoo.org>
Date: Mon, 15 Oct 2007 12:05:50 +0100
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070908)
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Marc Pignat <marc.pignat@hevs.ch>, linux-wireless@vger.kernel.org,
       kune@deine-taler.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zd1211rw, fix oops when ejecting install media
References: <200710150851.52995.marc.pignat@hevs.ch>
In-Reply-To: <200710150851.52995.marc.pignat@hevs.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Pignat wrote:
> The disconnect function can dereference the net_device structure before it is
> allocated. This is the case when ejecting the device installer.
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>

s/before it is allocated/when it is never allocated/

Acked-by: Daniel Drake <dsd@gentoo.org>

> ---
> 
> Hello!
> 
> Patch against 2.6.23.
> This patch fixes the bug I've submitted to linux-wireless friday in the
> "zd1211rw on 2.6.23 oops ejecting device" thread.
> 
> Regards
> 
> Marc
> 
> --- drivers/net/wireless/zd1211rw/zd_usb.c.orig	2007-10-15 08:29:16.000000000 +0200
> +++ drivers/net/wireless/zd1211rw/zd_usb.c	2007-10-15 08:29:32.000000000 +0200
> @@ -1041,14 +1041,17 @@ error:
>  static void disconnect(struct usb_interface *intf)
>  {
>  	struct net_device *netdev = zd_intf_to_netdev(intf);
> -	struct zd_mac *mac = zd_netdev_mac(netdev);
> -	struct zd_usb *usb = &mac->chip.usb;
> +	struct zd_mac *mac;
> +	struct zd_usb *usb;
>  
>  	/* Either something really bad happened, or we're just dealing with
>  	 * a DEVICE_INSTALLER. */
>  	if (netdev == NULL)
>  		return;
>  
> +	mac = zd_netdev_mac(netdev);
> +	usb = &mac->chip.usb;
> +
>  	dev_dbg_f(zd_usb_dev(usb), "\n");
>  
>  	zd_netdev_disconnect(netdev);
> 
> 


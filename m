Return-Path: <linux-kernel-owner+w=401wt.eu-S934412AbXGKWhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbXGKWhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934289AbXGKWhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:37:32 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:37818 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934247AbXGKWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:37:30 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH 01/02] Sierra Wireless - Add TRU-Install (c) Support
Date: Thu, 12 Jul 2007 00:37:27 +0200
User-Agent: KMail/1.9.7
Cc: Kevin Lloyd <klloyd@cs.hmc.edu>, gregkh@suse.de, linux@sierrawireless.com,
       torvalds@osdl.org, linux-kernel@vger.kernel.org
References: <46955982.1030905@cs.hmc.edu>
In-Reply-To: <46955982.1030905@cs.hmc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707120037.27672.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. Juli 2007 schrieb Kevin Lloyd:
> From: Kevin Lloyd <linux@sierrawireless.com>
> 
> This patch adds compatibility with Sierra Wireless' new TRU-Install feature. Future devices that use this feature will not work unless this patch has been applied.

Is this some type of CD-ROM simulation to provide drivers?

> +int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
> +{
> +	int result;	
> +	struct usb_device *udev;
> +
> +	udev = usb_get_dev(interface_to_usbdev(iface));
> +
> +	/* Check if in installer mode */
> +	if (id->driver_info == DEVICE_INSTALLER){
> +		dev_dbg("FOUND DEVICE(SW)\n");
> +		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
> +		return 0;

This is not a good idea in the long run. If you don't return an error here,
disconnect() will be called for your driver and will have to deal with
a semiinitialized device.

	Regards
		Oliver

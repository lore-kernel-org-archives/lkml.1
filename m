Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXGPLx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXGPLx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbXGPLxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:53:20 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:58477 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbXGPLxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:53:19 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH 01/02] USB: sierra: Add TRU-Install (c) Support [ATTEMPT 4]
Date: Mon, 16 Jul 2007 13:55:08 +0200
User-Agent: KMail/1.9.7
Cc: Kevin Lloyd <klloyd@sierrawireless.com>, gregkh@suse.de,
       linux@sierrawireless.com, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
References: <4696C9EF.9050406@sierrawireless.com>
In-Reply-To: <4696C9EF.9050406@sierrawireless.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707161355.08548.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 13 Juli 2007 schrieb Kevin Lloyd:
> +int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
> +{
> +       int result;     
> +       struct usb_device *udev;
> +
> +       udev = usb_get_dev(interface_to_usbdev(iface));
> +
> +       /* Check if in installer mode */
> +       if (id->driver_info == DEVICE_INSTALLER){
> +               dev_dbg(&udev->dev, "%s", "FOUND DEVICE(SW)\n");
> +               result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
> +               return result;

As I mentioned, you'd better return -EIO here. You don't want to bind
to the device, as it is not yet a serial device and you want the driver core
to stop trying while it goes away and transforms itself.

	Regards
		Oliver


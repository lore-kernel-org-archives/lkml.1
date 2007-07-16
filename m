Return-Path: <linux-kernel-owner+w=401wt.eu-S1765824AbXGPQ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765824AbXGPQ1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbXGPQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:27:27 -0400
Received: from evsync.sierrawireless.com ([204.50.29.40]:17050 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbXGPQ10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:27:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-usb-devel] [PATCH 01/02] USB: sierra: Add TRU-Install (c) Support [ATTEMPT 4]
Date: Mon, 16 Jul 2007 09:27:23 -0700
Message-ID: <3415E2A2AB26944B9159CDB22001004D01B0FCE7@nestea.sierrawireless.local>
In-Reply-To: <200707161355.08548.oliver@neukum.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] [PATCH 01/02] USB: sierra: Add TRU-Install (c) Support [ATTEMPT 4]
Thread-Index: AcfHn+tuWzDCBEV0TcOjmqUfHdH9YQAJiCgw
References: <4696C9EF.9050406@sierrawireless.com> <200707161355.08548.oliver@neukum.org>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Oliver Neukum" <oliver@neukum.org>,
       <linux-usb-devel@lists.sourceforge.net>
Cc: <gregkh@suse.de>, "Linux Development Group" <linux@sierrawireless.com>,
       <torvalds@osdl.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jul 2007 16:27:24.0648 (UTC) FILETIME=[3136DE80:01C7C7C6]
X-TM-AS-Product-Ver: SMEX-7.5.0.1166-5.0.1021-15296.001
X-TM-AS-Result: No--7.862200-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, thanks for spelling it out for me :) I misunderstood you before.

- Kevin 

-----Original Message-----
From: Oliver Neukum [mailto:oliver@neukum.org] 
Sent: Monday, July 16, 2007 4:55 AM
To: linux-usb-devel@lists.sourceforge.net
Cc: Kevin Lloyd; gregkh@suse.de; Linux Development Group; torvalds@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH 01/02] USB: sierra: Add TRU-Install (c) Support [ATTEMPT 4]

Am Freitag 13 Juli 2007 schrieb Kevin Lloyd:
> +int sierra_probe(struct usb_interface *iface, const struct 
> +usb_device_id *id) {
> +       int result;
> +       struct usb_device *udev;
> +
> +       udev = usb_get_dev(interface_to_usbdev(iface));
> +
> +       /* Check if in installer mode */
> +       if (id->driver_info == DEVICE_INSTALLER){
> +               dev_dbg(&udev->dev, "%s", "FOUND DEVICE(SW)\n");
> +               result = sierra_set_ms_mode(udev, 
> +SWIMS_SET_MODE_Modem);
> +               return result;

As I mentioned, you'd better return -EIO here. You don't want to bind to the device, as it is not yet a serial device and you want the driver core to stop trying while it goes away and transforms itself.

	Regards
		Oliver



Return-Path: <linux-kernel-owner+w=401wt.eu-S934117AbXGKWtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117AbXGKWtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763368AbXGKWti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:49:38 -0400
Received: from senderslist.sierrawireless.com ([204.50.29.40]:36222 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbXGKWti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:49:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-usb-devel] [PATCH 01/02] Sierra Wireless - Add TRU-Install (c) Support
Date: Wed, 11 Jul 2007 15:49:32 -0700
Message-ID: <3415E2A2AB26944B9159CDB22001004D01AD0D4D@nestea.sierrawireless.local>
In-Reply-To: <200707120037.27672.oliver@neukum.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] [PATCH 01/02] Sierra Wireless - Add TRU-Install (c) Support
Thread-Index: AcfEDBseB3wPXHI9RWaLSlAbwBzmEwAAIzfw
References: <46955982.1030905@cs.hmc.edu> <200707120037.27672.oliver@neukum.org>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Oliver Neukum" <oliver@neukum.org>,
       <linux-usb-devel@lists.sourceforge.net>
Cc: "Kevin Lloyd" <klloyd@cs.hmc.edu>, <gregkh@suse.de>, <torvalds@osdl.org>,
       <linux-kernel@vger.kernel.org>, <linux@sierrawireless.com>
X-OriginalArrivalTime: 11 Jul 2007 22:49:34.0111 (UTC) FILETIME=[C02C82F0:01C7C40D]
X-TM-AS-Product-Ver: SMEX-7.5.0.1166-5.0.1021-15290.002
X-TM-AS-Result: No--11.642100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately I can not myself comment on the feature at this point,
however the code is pretty obvious :).

I'll go ahead and change it so that it returns the result of
sierra_set_ms_mode.

Also, I realized that the second patch (02/02) fixes a bug in the first
patch (01/02), particularly the dev_dbg messages are implemented
incorrectly in the first patch. I'll move that fix up to the first
patch.

I'll wait another day for other comments and then resubmit with those
changes.

- Kevin

-----Original Message-----
From: Oliver Neukum [mailto:oliver@neukum.org] 
Sent: Wednesday, July 11, 2007 3:37 PM
To: linux-usb-devel@lists.sourceforge.net
Cc: Kevin Lloyd; gregkh@suse.de; Linux Development Group;
torvalds@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH 01/02] Sierra Wireless - Add
TRU-Install (c) Support

Am Donnerstag, 12. Juli 2007 schrieb Kevin Lloyd:
> From: Kevin Lloyd <linux@sierrawireless.com>
> 
> This patch adds compatibility with Sierra Wireless' new TRU-Install
feature. Future devices that use this feature will not work unless this
patch has been applied.

Is this some type of CD-ROM simulation to provide drivers?

> +int sierra_probe(struct usb_interface *iface, const struct 
> +usb_device_id *id) {
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

This is not a good idea in the long run. If you don't return an error
here,
disconnect() will be called for your driver and will have to deal with a
semiinitialized device.

	Regards
		Oliver


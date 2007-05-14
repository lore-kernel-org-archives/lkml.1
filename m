Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbXENXJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbXENXJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXENXJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:09:14 -0400
Received: from mail.sierrawireless.com ([204.50.29.40]:7487 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXENXJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:09:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] usb-storage: Add support for unusual device by Sierra Wireless
Date: Mon, 14 May 2007 16:10:27 -0700
Message-ID: <3415E2A2AB26944B9159CDB22001004D01773F61@nestea.sierrawireless.local>
In-Reply-To: <4648E9CB.2000509@gentoo.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb-storage: Add support for unusual device by Sierra Wireless
Thread-Index: AceWe9kfiBi8HUL4ThKvW2NTFGy21wAAESdg
References: <4648D851.2030500@sierrawireless.com> <4648E9CB.2000509@gentoo.org>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Daniel Drake" <dsd@gentoo.org>
Cc: <gregkh@suse.de>, <mdharm-usb@one-eyed-alien.net>,
       <linux-usb-users@lists.sourceforge.net>,
       <usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 May 2007 23:10:30.0829 (UTC) FILETIME=[1146F5D0:01C7967D]
X-TM-AS-Product-Ver: SMEX-7.5.0.1166-3.6.1039-15170.001
X-TM-AS-Result: No--10.263100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not a bad idea. When using the US_FL_IGNORE_DEVICE flag, that causes the
usb-storage driver to no load the device and allow another driver
properly load it? The reason I ask is because I previously had a
separate driver for the device, however there were priority issues
regarding which loaded first usb-storage or the separate driver.

Thanks,
   - Kevin

-----Original Message-----
From: Daniel Drake [mailto:dsd@gentoo.org] 
Sent: Monday, May 14, 2007 3:59 PM
To: Kevin Lloyd
Cc: gregkh@suse.de; mdharm-usb@one-eyed-alien.net;
linux-usb-users@lists.sourceforge.net;
usb-storage@lists.one-eyed-alien.net; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-storage: Add support for unusual device by
Sierra Wireless

Kevin Lloyd wrote:
> From: Kevin Lloyd <linux@sierrawireless.com>
> 
> This patch is targeted for the 2.6.21.1 kernel source. It adds support

> for Sierra Wireless devices with auto-install support to the 
> unusual_devices list of the usb-mass storage driver. This requires 
> changes to Kconfig, Makefile, usb.c, unusual_devs.h, and the addition 
> of sierra_ms.h & sierra_ms.c.

We have to do a similar thing for some zd1211rw USB-wireless devices,
which appear as a virtual CDROM drive on plugin. To convert them to a
proper wireless device, the cdrom has to be ejected, then the device
disconnects and reconnects with different ID's (and the wireless
endpoints).

Originally I wrote a usb-storage subdriver to handle the auto-eject, but
this was rejected. It was decided to make usb-storage simply ignore the
devices, and have the zd1211rw driver do the eject operation. The same
may also apply in your case. See the US_FL_IGNORE_DEVICE flag, and the
DEVICE_INSTALLER handling in drivers/net/wireless/zd1211rw/zd_usb.c

Daniel



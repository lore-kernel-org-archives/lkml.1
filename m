Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZA0VES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZA0VES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZA0VEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:04:05 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:39662 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZA0VEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:04:04 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: 2.6.29rc1 brakes usb
Date: Tue, 27 Jan 2009 22:04:21 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090126170130.GG6158@vanheusden.com> <200901262011.20545.oliver@neukum.org> <20090127195519.GB6158@vanheusden.com>
In-Reply-To: <20090127195519.GB6158@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901272204.22702.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 27 January 2009 20:55:20 schrieb Folkert van Heusden:
> On Mon, Jan 26, 2009 at 08:11:19PM +0100, Oliver Neukum wrote:
> > > Since version 2.6.29rc1 querying cleware USb devices no longer works.
> > > 2.6.28 works fine. 2.6.29-rc2 also no longer works.
> > 
> > What kind of device is this? What happens if you try to use the device?
> > Isn't it detected, do you get an error?
> 
> It is a powerswitch that can be toggled via USB. Cleware also has
> sensors (temperature, humidity, etc.) that all can be handled via a
> commandline utility I wrote.
> It has been a while but if i remember correctly the failing ioctl is for
> determing the serial number of the device. That is required to talk to
> the right device. http://www.vanheusden.com/clewarecontrol/

There's a known bug in hiddev. Please test the included patch.

	Regards
		Oliver

---

--- linux-2.6/drivers/hid/usbhid/hiddev.c.alt	2009-01-26 20:03:10.000000000 +0100
+++ linux-2.6/drivers/hid/usbhid/hiddev.c	2009-01-26 20:03:17.000000000 +0100
@@ -656,7 +656,7 @@ static long hiddev_ioctl(struct file *fi
 
 	case HIDIOCGSTRING:
 		mutex_lock(&hiddev->existancelock);
-		if (!hiddev->exist)
+		if (hiddev->exist)
 			r = hiddev_ioctl_string(hiddev, cmd, user_arg);
 		else
 			r = -ENODEV;

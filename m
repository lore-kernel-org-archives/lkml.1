Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbXE0JZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbXE0JZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 05:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXE0JZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 05:25:49 -0400
Received: from outpost.ds9a.nl ([213.244.168.210]:60005 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbXE0JZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 05:25:48 -0400
Date: Sun, 27 May 2007 11:25:46 +0200
From: bert hubert <bert.hubert@netherlabs.nl>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: udev regression? lsusb silent (no output) since 2.6.22-rc2 at  least
Message-ID: <20070527092546.GA10912@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
	gregkh@suse.de
References: <20070526201854.GA20758@outpost.ds9a.nl> <1180233755.3131.4.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180233755.3131.4.camel@lov.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 04:42:35AM +0200, Kay Sievers wrote:
> > Any clues? Please let me know how I can help solve this problem!
> 
> It works fine for me here. Do you have CONFIG_USB_DEVICE_CLASS=y set?

Ah, I have not. However, this setting was not present in 2.6.21-rc3, from
which configuration I ran 'make oldconfig'.

Make oldconfig does ask for this feature:
  USB device class-devices (DEPRECATED) (USB_DEVICE_CLASS) [N/y/?] (NEW) 

And I chose the default, breaking (my version of) lsusb, on Ubuntu Edgy Eft.
I enabled USB_DEVICE_CLASS, and lsusb worked again.

Thank you both for your quick answers!

Please consider this patch which clarifies the need for USB_DEVICE_CLASS:

--- ./drivers/usb/core/Kconfig~	2007-05-27 11:22:22.000000000 +0200
+++ ./drivers/usb/core/Kconfig	2007-05-27 11:22:22.000000000 +0200
@@ -54,7 +54,8 @@
 	  device of the interface and therefore easily accessible from the interface
 	  event.
 
-	  This option provides backward compatibility if needed.
+	  This option provides backward compatibility and is required on
+	  many distributions to keep lsusb working.
 
 config USB_DYNAMIC_MINORS
 	bool "Dynamic USB minor allocation (EXPERIMENTAL)"

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services

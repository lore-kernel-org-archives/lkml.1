Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYBNPwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYBNPwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYBNPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:52:28 -0500
Received: from mail16c2.megamailservers.com ([216.251.41.136]:45937 "EHLO
	mail16c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705AbYBNPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:52:28 -0500
X-Greylist: delayed 3283 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 10:52:27 EST
X-Authenticated-User: stephan.eciinternational.de
Subject: PL2303 Driver missing support for USB to Serial Cable
From: Stephan Rose <stephan@eciinternational.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 09:57:40 -0500
Message-Id: <1203001060.8420.11.camel@software>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently purchased a USB->Com Port serial cable from Radio Shack
(Model number 26-183) which did no seem to want to work. After looking
into it I discovered that it is based on the Prolific chipset using the
PL2303 driver. 

I then checked the Vendor and Product ID against the list in the drive
and sure enough, the IDs were missing in the driver.

So here are my modifications to the PL2303 driver which have been
working flawlessly on my system the whole week:

drivers/usb/serial/pl2303.h
--------

/* Radio Shack 26-183 */
#define RADIOSHACK26183_VENDOR_ID 0x05ad
#define RADIOSHACK26183_PRODUCT_ID 0x0fba

drivers/usb/serial/pl2303.c
--------

Added to struct usb_device_id id_table

{ USB_DEVICE(RADIOSHACK26183_VENDOR_ID RADIOSHACK26183_PRODUCT_ID) }

I still have to manually modprobe the module as the kernel won't
automatically load it when I connect the device, no idea what I would
need to change where for that to happen.

The above though does successfully add support for that serial cable so
I thought I'd share it with the kernel list so that it can possibly be
added to the kernel and I can stop having to re-compile the driver every
kernel update. :)

Please feel free to contact me if needed.

Thanks!

Stephan




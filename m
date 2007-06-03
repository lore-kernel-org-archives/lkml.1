Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbXFCJ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbXFCJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 05:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbXFCJ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 05:56:01 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38548 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbXFCJ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 05:56:00 -0400
Date: Sun, 3 Jun 2007 11:55:50 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706031151090.29896@twin.jikos.cz>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have looked into NUT source and it seems that this error message is 
output after interaction with libusb, not hiddev. It looks like libusb's 
usb_claim_interface() or usb_control_msg() in in 2.6.22-rc3 is failing 
with -EPERM.

So I am adding USB devel mailinglist into CC and leaving the original 
message below for reference.

On Sat, 2 Jun 2007, Justin Piszcz wrote:

> I use nut-2.0.4-4 with a UPS attached via USB and from 2.6.21.3 -> 2.6.22-rc3
> it stops working, see below.  My .config is attached.
> 
> 2.6.21.3:
> 
> p34:~# /lib/nut/newhidups -u nut -DDDDDD auto
> Checking device (050D/0912) (005/002)
> - VendorID: 050d
> - ProductID: 0912
> - Manufacturer:
> - Product: UPS
> - Serial Number: unknown
> - Bus: 005
> Trying to match device
> Device matches
> HID descriptor retrieved (Reportlen = 820)
> Size read for the report descriptor: 820
> Report descriptor retrieved (Reportlen = 820)
> Found HID device
> Network UPS Tools: New USB/HID UPS driver 0.28 (2.0.4)
> 
> Report Descriptor size = 820
> Report Descriptor: (200 bytes) => 05 84 09 04 A1 01 05 86 09 26 A1 02 85 01 75
> 08
> Detected a UPS:        /UPS
> Using subdriver: Belkin HID 0.1
> Looking up 00840004
> Looking up 00860026
> Looking up 00860040
> entering string_to_path()
> parsing UPS
> Looking up UPS
> hid_lookup_usage: found 840004
> parsing BELKINConfig
> Looking up BELKINConfig
> hid_lookup_usage: found 860026
> parsing BELKINConfigVoltage
> Looking up BELKINConfigVoltage
> hid_lookup_usage: found 860040
> Path depth = 3
> 0: UPage(84), Usage(4)
> 1: UPage(86), Usage(26)
> 2: UPage(86), Usage(40)
> Entering libusb_get_report
> =>> Before exponent: 120, 0/0)
> =>> After conversion: 120.000000 (120), 0/0)
> Report : (8 bytes) => 01 78 80 00 00 00 00 00
> Path: UPS.BELKINConfig.BELKINConfigVoltage, Type: Feature, Value: 120.000000
> Looking up 00840004
> Looking up 00860026
> Looking up 00860042
> 
> (works fine)
> 
> 2.6.22-rc3:
> 
> p34:~# /lib/nut/newhidups -u nut -DDDDDD auto
> Checking device (050D/0912) (005/002)
> - VendorID: 050d
> - ProductID: 0912
> - Manufacturer: unknown
> - Product: unknown
> - Serial Number: unknown
> - Bus: 005
> Trying to match device
> Device matches
> failed to claim USB device, trying 2 more time(s)...
> detaching kernel driver from USB device...
> failed to detach kernel driver from USB device...
> trying again to claim USB device...
> failed to claim USB device, trying 1 more time(s)...
> detaching kernel driver from USB device...
> failed to detach kernel driver from USB device...
> trying again to claim USB device...
> failed to claim USB device, trying 0 more time(s)...
> detaching kernel driver from USB device...
> failed to detach kernel driver from USB device...
> trying again to claim USB device...
> Unable to get HID descriptor (error sending control message: Operation not
> permitted)
> 
> 

-- 
Jiri Kosina

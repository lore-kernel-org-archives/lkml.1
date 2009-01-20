Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbZATUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbZATUur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762925AbZATUuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:50:14 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:20892 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762829AbZATUuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:50:09 -0500
Message-ID: <497638FF.8050805@msgid.tls.msk.ru>
Date: Tue, 20 Jan 2009 23:50:07 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Subject: "permanently" unbind a device from a driver?
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to stop a module from claiming a
given device no matter how/when it gets plugged?

For example, there's a series of power supplies
(UPSes) with USB connection (common nowadays)
which, by default, gets claimed by usbhid module.
But it does not work as a HID device, instead it
uses a serial line logic and has a USB<=>serial
converter inside, which works just fine with
cypress_m8 usbserial driver.

usbhid module is loaded on startup (to handle
usb keyboards/mouses), and it claims this device
too.  Using /sys/bus/.../drivers/usbhid/unbind
releases it, after which cypress_m8 works as
expected.  But after re-plugging it gets claimed
by usbhid again.

I understand that it's easy to write an udev rule
(I don't use udev but that's another story) to
unbind the device from the driver and bind it to
another driver automatically.  That's basically
what I have for now (handling hidraw* device).
But that seems somewhat... ugly, at best.

The question is: is it possible to tell usbhid
to STOP claiming devices with given vendor:device
identifier, from now on?

I also understand that to do it permanently the
given vendor:device has to be blacklisted in the
driver source.  But I don't think it's worth the
effort.  Sort of runtime blacklist support --
possible?

Thanks!

/mjt

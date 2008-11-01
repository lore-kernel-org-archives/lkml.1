Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYKAU0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYKAU0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 16:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYKAU0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 16:26:33 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59926 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYKAU0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 16:26:32 -0400
Date: Sat, 1 Nov 2008 21:26:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Adam Nielsen <a.nielsen@shikadi.net>
cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: Can you use the USB HID interface within a driver?
In-Reply-To: <490C4133.30400@shikadi.net>
Message-ID: <alpine.LRH.1.10.0811012122250.19257@twin.jikos.cz>
References: <490C4133.30400@shikadi.net>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, Adam Nielsen wrote:

> I would rather write the driver in kernel space (so that it "just works" 
> and provides a hwmon interface without installing extra software), 
> however the device already appears to the system as a USB HID device, 
> and so gets claimed by the existing usbhid driver.

There is a long blacklist/ignorelist in the usbhid driver, for the VID/PID 
combinations that we don't want to have claimed by usbhid driver, because 
there is a more specific one.

> Is there any way to interface with the HID driver from within another 
> driver? Or will I have to claim the device first (or disconnect usbhid), 
> and communicate with it myself?
> I've tried to find some example code from a driver that already does this
> (such as a USB keyboard driver) but I'm having some trouble finding one!  The
> closest drivers I can find are all the ones in drivers/hid/usbhid, but they
> all seem to be "embedded" in hid-core.c. Does that mean I need to modify
> hid-core.c to call my driver?

For 2.6.28, the HID code has been completely refactored, and converted 
into a proper bus, making it possible to write driver easily in a way that 
the driver implements only parts where device deviates from the HID 
standard, and lets the rest to be handled by generic code. I guess this is 
what you are looking for?

Please look at drivers/hid in 2.6.28-rc1 or newer. There are quite a 
couple of drivers already using this new infrastructure.

If you have any further questions, I'll be happy to help you, but I will 
be completely offline until 11th November, sorry.

Hope this helps,

-- 
Jiri Kosina
SUSE Labs


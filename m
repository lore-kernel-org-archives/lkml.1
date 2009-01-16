Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbZAPNU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbZAPNU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbZAPNUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:20:45 -0500
Received: from styx.suse.cz ([82.119.242.94]:51107 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760996AbZAPNUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:20:44 -0500
Date: Fri, 16 Jan 2009 14:20:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Javantea <javantea@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: HID merge plans for 2.6.28
In-Reply-To: <47c482f50901150654t21f4598cj1d081b1ae6d3177d@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0901161415010.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0810091420250.26779@jikos.suse.cz> <47c482f50901150654t21f4598cj1d081b1ae6d3177d@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Javantea wrote:

> Users were using HID_QUIRK_IGNORE in modprobe.conf to turn off usbhid 
> for a specific device. Is there a better way to do this now in 2.6.28? 
> It seems like there are more modules that a person would like to turn 
> off for one device and on for another device. For me, the device is the 
> RockBand 2 drumset which identifies as a USB HID, but the velocity is 
> ignored by usbhid, so I wrote a userland "driver" for it with libusb 
> that takes velocity into account. libusb is unable to claim the device 
> so long as usbhid has claimed it.

There are several options:

1) write a kernel-level driver for this device; with the new hid bus 
   inftrastructure in place, this is quite easy. This has the advantage 
   that once the driver gets merged, all the users with new kernel will 
   have the driver automatically available

2) unbind the driver from the device via sysfs. libusb should have API for 
   this as well, usb_detach_kernel_driver_np() if I remember correctly

-- 
Jiri Kosina
SUSE Labs

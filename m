Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbXFCQwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbXFCQwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 12:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXFCQwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 12:52:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56352 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXFCQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 12:52:13 -0400
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor
	(error sending control message: Operation not permitted)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706030837480.3790@p34.internal.lan>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
	 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz>
	 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
	 <Pine.LNX.4.64.0706031300240.29896@twin.jikos.cz>
	 <Pine.LNX.4.64.0706030716070.3574@p34.internal.lan>
	 <Pine.LNX.4.64.0706031321450.29896@twin.jikos.cz>
	 <Pine.LNX.4.64.0706030749580.3653@p34.internal.lan>
	 <3ae72650706030535k26f9d982t382d8fd145c4e966@mail.gmail.com>
	 <Pine.LNX.4.64.0706030837480.3790@p34.internal.lan>
Content-Type: text/plain
Date: Sun, 03 Jun 2007 18:51:21 +0200
Message-Id: <1180889481.7793.20.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+utW8+qCQLFWQxoUgdCO/u8gQ4NFpbATSBGYm
 p8gqIhH4VjxP2A++velTRTLVPrRmxTbwut0/4thxFJxcKIrWbn
 +Xz5urT7IH5iz+MRxMnAngh9SKL8z3S
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-03 at 08:40 -0400, Justin Piszcz wrote: 
> On Sun, 3 Jun 2007, Kay Sievers wrote:
> 
> > On 6/3/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >> On Sun, 3 Jun 2007, Jiri Kosina wrote:
> >> 
> >> > On Sun, 3 Jun 2007, Justin Piszcz wrote:
> >> >
> >> >>> Thanks. Does by any chance reverting the commit
> >> >>> 9f8b17e643fe6aa505629658445849397bda4e4f improve the situation?
> >> >> I have not played around with git/etc enough to back it out, if you have 
> >> a
> >> >> patch that applies on top of 2.6.22-rc3 that backs it out I can give it 
> >> a try.
> >> >
> >> > Please try this
> >> 
> >> [[ .. snip .. ]]
> >> 
> >> The patch was successful and now my USB device is working again!
> >
> > Please set:
> > CONFIG_USB_DEVICE_CLASS=y
> > there should be no patch needed. The option already defaults to yes in
> > the latest kernel.

> USB device class-devices (DEPRECATED) (USB_DEVICE_CLASS) [N/y/?] (NEW) y
> 
> Why is it deprecated if (nut/usb/etc fails) when its not used?  Does nut 
> or udev have to play catch-up to adhere to the new kernel changes?

The usb_device class was created to replace the /proc usbfs device nodes
which can't handle access-control-lists for logged-in users.
The device nodes worked fine, but plugging into the device events to
trigger userspace device handling created a bunch of problems with the
event timing. We have several open bugs, that can't be fixed properly
with using the usb_device-devices.

We changed the driver core to allow us to export device nodes directly
by bus-devices, instead of forcing us to create artificial devices like
the usb_device-class, just to export device nodes to userspace. If
systems set CONFIG_USB_DEVICE_CLASS=n (which defaults to yes now), one
new udev rule is needed, to replace the functionality of the
usb_device-class devices. Also the next version of HAL (which is where
nut receives the events from) will depend on the new device nodes, and
will not longer use usb_device devices. No changes to nut should be
needed.

Thanks,
Kay


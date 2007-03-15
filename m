Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXCOVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXCOVnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXCOVnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:43:32 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46063 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbXCOVnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:43:31 -0400
Date: Thu, 15 Mar 2007 22:43:12 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [linux-usb-devel] USB Keyboard
In-Reply-To: <Pine.LNX.4.61.0703151541430.4459@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0703152236390.12394@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0703151506010.2482-100000@iolanthe.rowland.org>
 <Pine.LNX.4.61.0703151541430.4459@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, linux-os (Dick Johnson) wrote:

[...]
> The initrd "linuxrc" file that loads the modules is here. One can see 
> the order in which the modules are loaded. We had to make our own shell 
> to replace 'nash' because the SCSI drivers spawned "children" that 
> confused nash with SIGCHLD when they executed.
[...]
> echo "Loading uhci-hcd.ko module"
> insmod /lib/uhci-hcd.ko
> echo "Loading ehci-hcd.ko module"
> insmod /lib/ehci-hcd.ko
> echo "Loading usbhid.ko module"
> insmod /lib/usbhid.ko
> echo "Loading usbkbd.ko module"
> insmod /lib/usbkbd.ko

Could you please try to *not* insmod usbkbd module? Or is there any 
special particular reason for you doing so? 

This module is not what should be used in a normal situation on production 
and fully working systems. Everything for USB keyboard to work is normally 
handled by the usbhid module. Please see the description of what usbkbd 
is:

config USB_KBD
        tristate "USB HIDBP Keyboard (simple Boot) support"
        depends on USB && INPUT
        ---help---
          Say Y here only if you are absolutely sure that you don't want
          to use the generic HID driver for your USB keyboard and prefer
          to use the keyboard in its limited Boot Protocol mode instead.

          This is almost certainly not what you want.  This is mostly
          useful for embedded applications or simple keyboards.

          To compile this driver as a module, choose M here: the
          module will be called usbkbd.

          If even remotely unsure, say N.

The module could be buggy, your keyboard might be hidbp incompatible, or 
whatever. usbkbd is very rarely used and is there only for really special 
ocasions, as the Kconfig help text clearly states.

So could you please try without this module loaded and let me know the 
result?

-- 
Jiri Kosina

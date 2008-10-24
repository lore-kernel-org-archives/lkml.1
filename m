Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYJXN5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYJXN5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYJXN5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:57:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54194 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751307AbYJXN5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:57:38 -0400
Date: Fri, 24 Oct 2008 09:57:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbcore: Limit number of 'unable to enumerate USB device'
 messages
In-Reply-To: <49010A25.6020702@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.0810240954370.13114-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Larry Finger wrote:

> In my system, a number of messages that state "unable to enumerate USB device"
> are logged. These are intermittent and likely due to some race condition
> at bootup.
> 
> Some of these happen when the EHCI driver is loaded after UHCI or OHCI, which
> causes the device to be switched away from the other controller that's trying
> to enumerate it, at least momentarily. This type of message is logged at most
> once for each hub and occurs in about 70% of my reboots.

This is normal; it is caused by userspace loading the drivers in the
wrong order.  ehci-hcd is supposed to be loaded before uhci-hcd or
ohci-hcd, not after.  There's no point trying to change the kernel to
avoid it.

> A more insidious form of the message occurs hundreds of times in about 10% of
> reboots. They continue until the system is rebooted. This patch limits the
> number of these messages to 20. Once the actual cause of this message is
> located, this patch can be reverted.

I would prefer to attack this problem directly rather than wallpaper 
over it.  Can you provide more information?  For example, a dmesg log 
with CONFIG_USB_DEBUG and CONFIG_PRINTK_TIME enabled would help.  It 
might also help to know what the devices which can't be enumerated 
actually are.

Alan Stern


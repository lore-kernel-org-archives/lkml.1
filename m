Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZBTU21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZBTU21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZBTU2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:28:14 -0500
Received: from kroah.org ([198.145.64.141]:35737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753635AbZBTU2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:28:13 -0500
Date: Fri, 20 Feb 2009 11:10:12 -0800
From: Greg KH <greg@kroah.com>
To: Shivdas Gujare <shivdas.tech@gmail.com>, alan@lxorguk.ukuu.org.uk
Cc: beagleboard@googlegroups.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Warning/crash using usb-serial device
Message-ID: <20090220191012.GA5256@kroah.com>
References: <cf70f0210902200415k5326f593nae55b53b83802797@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf70f0210902200415k5326f593nae55b53b83802797@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 05:45:04PM +0530, Shivdas Gujare wrote:
> Hi all,
> 
> Currently I am testing USB serial device with BeagleBoard(omap3) which
> uses musb host controller. But I gets following Warnings every time
> if I tries to open the /dev/ttyUSB0 using simple application which I
> have written to open/read and write.
> 
> FYI, I currently tested with 2.6.29-rc5 and also 2.6.29-rc2, with no success.
> 
> What could be the possible reason? Is there any way, I can avoid this warning?
> Thanks for your valuable help.
> 
> Regards,
> Shivdas
> 
> 
> ------------[ cut here ]------------
> WARNING: at kernel/mutex.c:135 __mutex_lock_slowpath+0x6c/0x234()
> Modules linked in: usbserial
> [<c029d188>] (dump_stack+0x0/0x14) from [<c00516b4>] (warn_slowpath+0x68/0x9c)
> [<c005164c>] (warn_slowpath+0x0/0x9c) from [<c029e0d0>]
> (__mutex_lock_slowpath+0x6c/0x234)
>  r3:c039437c r2:00000000
>  r7:c787e9c0 r6:c7bc6c00 r5:c7bc6fb4 r4:c7bc6c00
> [<c029e064>] (__mutex_lock_slowpath+0x0/0x234) from [<c029e2a8>]
> (mutex_lock+0x10/0x14)
> [<c029e298>] (mutex_lock+0x0/0x14) from [<c01a0d10>]
> (echo_set_canon_col+0x1c/0x40)
> [<c01a0cf4>] (echo_set_canon_col+0x0/0x40) from [<c01a2bcc>]
> (n_tty_receive_buf+0xbdc/0x1074)
>  r5:00000000 r4:000000fe
> [<c01a1ff0>] (n_tty_receive_buf+0x0/0x1074) from [<c01a513c>]
> (flush_to_ldisc+0xf0/0x184)
> [<c01a504c>] (flush_to_ldisc+0x0/0x184) from [<c01a520c>]
> (tty_flip_buffer_push+0x3c/0x4c)
> [<c01a51d0>] (tty_flip_buffer_push+0x0/0x4c) from [<bf0028b8>]
> (usb_serial_generic_read_bulk_callback+0x12c/0x170 [usbserial])
> [<bf00278c>] (usb_serial_generic_read_bulk_callback+0x0/0x170
> [usbserial]) from [<c01e60b8>] (usb_hcd_giveback_urb+0xb0/0xfc)
>  r8:c78d88d8 r7:00000000 r6:c78d8800 r5:00000000 r4:c7851440
> [<c01e6008>] (usb_hcd_giveback_urb+0x0/0xfc) from [<c01f8148>]
> (__musb_giveback+0xf4/0x110)

Ick.  Alan, echo_set_cannon_col is being called from
tty_flip_buffer_push and trying to grab a mutex, yet we are in interrupt
context as we are in a USB urb callback.

Any thoughts?

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZBQDYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZBQDYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZBQDXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:23:48 -0500
Received: from kroah.org ([198.145.64.141]:35474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828AbZBQDXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:23:47 -0500
Date: Mon, 16 Feb 2009 19:14:43 -0800
From: Greg KH <greg@kroah.com>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: ttyUSB sendbreak problem
Message-ID: <20090217031443.GA8343@kroah.com>
References: <4999F6C8.3050001@sysnux.pf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4999F6C8.3050001@sysnux.pf>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:29:12PM -1000, Jean-Denis Girard wrote:
> Hi list,
> 
> I'm writing a program which communicates via modem with an embedded
> device (electrical network monitoring). The frames are terminated by a
> BREAK.
> 
> My program works fine when I use a Cyclades 8Yo multiports card, but
> fails using USB to serial adapters (tried with pl2303 and FTDI
> converters). I suspect that the BREAK are not passed correctly, but I
> don't have equipment to check.

Odd, pl2303 should support break just fine.

> I've tried with:
>  tcsendbreak(modem,0);
>  ioctl(modem, TCSBRK,0);
>  ioctl(modem, TCSBRKP, 0);
> 
> From pl2303 debug mode, I see that pl2303_break_ctl is called:
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - port 0
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - turning break on
>  drivers/usb/serial/pl2303.c: pl2303_write_bulk_callback - port 0
>  drivers/usb/serial/pl2303.c: pl2303_send - port 0
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - port 0
>  drivers/usb/serial/pl2303.c: pl2303_break_ctl - turning break off
> 
> I found a few references of similar problems in the past, but it was for
> older kernels (I'm using 2.6.28.4), so the question remains: should it
> work or is there a known problem sending BREAK using ttyUSB?

It should work, but your specific device might not support the break
control (some seem to and others don't.)  It's a very cheap device.

You might want to try a more expensive device, like the io networks
devices, break on them should work just fine as they have a "real" uart
device within them.

good luck,

greg k-h

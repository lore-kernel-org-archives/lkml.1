Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYK1WdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYK1WdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYK1Wc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:32:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752520AbYK1Wc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:32:58 -0500
Date: Fri, 28 Nov 2008 22:33:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Message-ID: <20081128223305.2d11f8d9@lxorguk.ukuu.org.uk>
In-Reply-To: <1227911282-8857-1-git-send-email-keithp@keithp.com>
References: <200811281642.52637.arnd@arndb.de>
	<1227911282-8857-1-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 14:28:02 -0800
Keith Packard <keithp@keithp.com> wrote:

> USB serial devices with extended IOCTLs cannot be used in a 64-bit kernel
> from 32-bit user space as the compat_ioctl path is missing. This adds a
> pass-through so that drivers may offer this functionality. This requires
> that all drivers actually implement a compat_ioctl function if they want to
> support this operation.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Would be far better to keep compatible ioctls anyway however that aside
clearly it should be passed on.

> +static int serial_compat_ioctl(struct tty_struct *tty, struct file *file,
> +			       unsigned int cmd, unsigned long arg)
> +{
> +	struct usb_serial_port *port = tty->driver_data;
> +	int retval = -ENODEV;

Can never be used only overwritten so why not replace with -ENOIOCTLCMD
and remove the else of the if

Also I get a CodingStyle whine about the port->serial-> side of the if
not needing { }

> +	/* Called with bkl held */
>  	int  (*ioctl)(struct tty_struct *tty, struct file *file,
>  		      unsigned int cmd, unsigned long arg);

No... the ioctl path for tty comes from unlocked_ioctl so the BKL is not
held and should not be held.

Alan

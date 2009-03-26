Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbZCZTne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbZCZTne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760988AbZCZTnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:43:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48966 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759990AbZCZTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:43:23 -0400
Date: Thu, 26 Mar 2009 19:44:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com
Subject: Re: USB: symbolserial: log the ioctl commands
Message-ID: <20090326194421.41816289@lxorguk.ukuu.org.uk>
In-Reply-To: <200903261929.n2QJTUX1009811@hera.kernel.org>
References: <200903261929.n2QJTUX1009811@hera.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static int symbol_tiocmget(struct tty_struct *tty, struct file *file)
> +{
> +	struct usb_serial_port *port = tty->driver_data;
> +	struct device *dev = &port->dev;
> +
> +	/* TODO */
> +	/* probably just need to shadow whatever was sent to us here */
> +	dev_info(dev, "%s\n", __func__);
> +	return 0;
> +}

If you don't have a modem you don't provide these methods. If you do have
a modem you return the values for the modem. Please do not try and stick
in stuff faking responses, it just makes a nasty mess in the longer term
and I've already cleared the same out of a ton of drivers - with I note
no breakages of user space.


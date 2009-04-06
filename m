Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZDFFph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZDFFph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZDFFoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:44:30 -0400
Received: from kroah.org ([198.145.64.141]:47446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752272AbZDFFo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:44:29 -0400
Date: Sun, 5 Apr 2009 22:40:14 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB: symbolserial: log the ioctl commands
Message-ID: <20090406054014.GB12019@kroah.com>
References: <200903261929.n2QJTUX1009811@hera.kernel.org> <20090326194421.41816289@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326194421.41816289@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 07:44:21PM +0000, Alan Cox wrote:
> 
> > +static int symbol_tiocmget(struct tty_struct *tty, struct file *file)
> > +{
> > +	struct usb_serial_port *port = tty->driver_data;
> > +	struct device *dev = &port->dev;
> > +
> > +	/* TODO */
> > +	/* probably just need to shadow whatever was sent to us here */
> > +	dev_info(dev, "%s\n", __func__);
> > +	return 0;
> > +}
> 
> If you don't have a modem you don't provide these methods. If you do have
> a modem you return the values for the modem. Please do not try and stick
> in stuff faking responses, it just makes a nasty mess in the longer term
> and I've already cleared the same out of a ton of drivers - with I note
> no breakages of user space.

I'm trying to get this driver working properly for a USB device that is
being controlled by a Windows program running under WINE.  Right now
there are some ioctls being called by either WINE or the serial program
on Windows that the driver isn't handling and so it's not working
properly.  This change was so that I could get feedback from the user
with this situation to try to work it all out.

I've now got a trace of an attempt and will work to try to implement the
needed ioctls to get it running properly.

thanks,

greg k-h

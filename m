Return-Path: <linux-kernel-owner+w=401wt.eu-S1031519AbXD1LhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031519AbXD1LhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031522AbXD1LhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:37:24 -0400
Received: from www.osadl.org ([213.239.205.134]:46444 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031519AbXD1LhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:37:23 -0400
Subject: Re: Flaws with "UIO: Add the User IO core code"
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Benedikt Spranger <b.spranger@linutronix.de>
In-Reply-To: <20070428001923.15074234@the-village.bc.nu>
References: <20070427224957.GA17967@kroah.com>
	 <11777142582534-git-send-email-gregkh@suse.de>
	 <20070428001923.15074234@the-village.bc.nu>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 13:39:27 +0200
Message-Id: <1177760367.7646.116.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 00:19 +0100, Alan Cox wrote:
> > +static ssize_t uio_read(struct file *filep, char __user *buf,
> > +			size_t count, loff_t *ppos)
> > +{
> > +	struct uio_listener *listener = filep->private_data;
> > +	struct uio_device *idev = listener->dev;
> > +	DECLARE_WAITQUEUE(wait, current);
> > +	ssize_t retval;
> > +	int event_count;
> > +
> > +	if (idev->info->irq == UIO_IRQ_NONE)
> > +		return -EIO;
> > +
> > +	if (count != sizeof(int))
> > +		return -EINVAL;
> 
> AFAIK we don't currently have any platform that runs binaries with
> different sizes of "int" but this is a) an unsigned value anyway, and b)
> should be a fixed type (eg u32)

Good point.

> Otherwise it looks ok at the momenmt, although there is a real nasty
> waiting for anyone who tries to use it. At the point open is possible or
> IRQs can be enabled you are safe in the core merged as idev->info is
> always valid, but any driver module trying to go back via info->uio_dev
> has a NULL pointer for an early IRQ or open event.
> 
> This means that the fasync support in the current code is basically
> unusable until this is fixed

We'll fix that ASAP.

	tglx



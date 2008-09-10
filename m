Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbYIJAgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbYIJAgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYIJAgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:36:09 -0400
Received: from scing.com ([217.160.110.58]:60237 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYIJAgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:36:08 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 04/18] lirc driver for 2nd-gen and later Media Center Ed. USB IR transceivers
Date: Wed, 10 Sep 2008 02:36:03 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>, Janne Grunau <j@jannau.net>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-5-git-send-email-jwilson@redhat.com> <20080909173057.6d93a7ef@bike.lwn.net>
In-Reply-To: <20080909173057.6d93a7ef@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809100236.04016.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 01:30:57 Jonathan Corbet wrote:
> On Tue,  9 Sep 2008 00:05:49 -0400
>
> Jarod Wilson <jwilson@redhat.com> wrote:
> > +/*
> > + * LIRC driver for Philips eHome USB Infrared Transceiver
> > + * and the Microsoft MCE 2005 Remote Control
> > + *
> > + * (C) by Martin A. Blatter <martin_a_blatter@yahoo.com>
> > + *
> > + * Transmitter support and reception code cleanup.
> > + * (C) by Daniel Melander <lirc@rajidae.se>
>
> As I understand it, proper assertions of copyright need the word
> "copyright" and a year; the "(C)" trigraph doesn't have any legal
> meaning.

Depends on the country. I won't touch copyright notices or attributions.

> > + * This driver will only work reliably with kernel version 2.6.10
> > + * or higher, probably because of differences in USB device
> > enumeration + * in the kernel code. Device initialization fails
> > most of the time + * with earlier kernel versions.
>
> My guess is that this will not be a major impediment to mainline
> inclusion; this comment can probably go.

Already removed.

> > +/* lock irctl structure */
> > +#define IRLOCK		mutex_lock(&ir->lock)
> > +#define IRUNLOCK	mutex_unlock(&ir->lock)
>
> Might I request that these go away?  They can only obfuscate the
> code.

yes, I will manually expand similar macros in the other drivers too.

> Also, set_use_inc() is returning a normal zero-or-negative-error
> status to an outside caller.  It shouldn't return a locally-defined
> symbol like SUCCESS.  I'd just use "return 0;".

fixed

> > +#ifdef MODULE
> > +static int __init usb_remote_init(void)
> > +{
>
> I'm curious: you don't need to initialize if not compiled as a
> module?

Already fixed in all drivers, relict from out of tree lirc.

> > +	int i;
> > +
> > +	printk(KERN_INFO "\n");
> > +	printk(KERN_INFO DRIVER_NAME ": " DRIVER_DESC " " DRIVER_VERSION
> > "\n"); +	printk(KERN_INFO DRIVER_NAME ": " DRIVER_AUTHOR "\n");
> > +	dprintk(DRIVER_NAME ": debug mode enabled\n");
> > +
> > +	request_module("lirc_dev");
>
> You're calling functions from lirc_dev.c, so modprobe will not load
> this module until lirc_dev is already there.  There's no point in
> trying to load it explicitly with request_module().

True, request_module("lirc_dev"); removed from all drivers.

> > +	i = usb_register(&usb_remote_driver);
> > +	if (i < 0) {
> > +		printk(DRIVER_NAME ": usb register failed, result = %d\n", i);
> > +		return -ENODEV;
> > +	}
> > +
> > +	return SUCCESS;
> > +}
>
> "return 0;" please.

fixed for all drivers

Janne

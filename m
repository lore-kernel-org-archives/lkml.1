Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXKHWY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXKHWY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbXKHWYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:24:52 -0500
Received: from ozlabs.org ([203.10.76.45]:47565 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbXKHWYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:24:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] virtio config_ops refactoring
Date: Fri, 9 Nov 2007 09:24:28 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anthony Liguori <aliguori@us.ibm.com>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org
References: <4730A8F3.6020008@us.ibm.com> <200711081320.35844.rusty__6233.15023626692$1194488552$gmane$org@rustcorp.com.au> <4732774C.6020903@codemonkey.ws>
In-Reply-To: <4732774C.6020903@codemonkey.ws>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711090924.28659.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 13:41:16 Anthony Liguori wrote:
> Rusty Russell wrote:
> > On Thursday 08 November 2007 04:30:50 Anthony Liguori wrote:
> >> I would prefer that the virtio API not expose a little endian standard.
> >> I'm currently converting config->get() ops to ioreadXX depending on the
> >> size which already does the endianness conversion for me so this just
> >> messes things up.  I think it's better to let the backend deal with
> >> endianness since it's trivial to handle for both the PCI backend and the
> >> lguest backend (lguest doesn't need to do any endianness conversion).
> >
> > -ETOOMUCHMAGIC.  We should either expose all the XX interfaces (but this
> > isn't a high-speed interface, so let's not) or not "sometimes" convert
> > endianness. Getting surprises because a field happens to be packed into 4
> > bytes is counter-intuitive.
>
> Then I think it's necessary to expose the XX interfaces.  Otherwise, the
> backend has to deal with doing all register operations at a per-byte
> granularity which adds a whole lot of complexity on a per-device basis
> (as opposed to a little complexity once in the transport layer).

Huh?  Take a look at the drivers, this simply isn't true.  Do you have 
evidence that it will be true later?

Plus your code will be smaller doing a single writeb/readb loop than trying to 
do a switch statement.

> You really want to be able to rely on multi-byte atomic operations too
> when setting values.  Otherwise, you need another register to just to
> signal when it's okay for the device to examine any given register.

You already do; the status register fills this role.  For example, you can't 
tell what features a guest understands until it updates the status register.

Hope that clarifies,
Rusty.

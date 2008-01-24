Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYAXRfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYAXRfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYAXRew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:34:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53976 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYAXRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:34:52 -0500
Date: Thu, 24 Jan 2008 09:20:49 -0800
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Wilco Beekhuizen <wilcobeekhuizen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Message-ID: <20080124172049.GA9665@kroah.com>
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <20080124013720.GA21978@kroah.com> <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com> <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com> <20080124164418.GA8226@kroah.com> <84144f020801240906l7e018a95wfd4ad7736851dd63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020801240906l7e018a95wfd4ad7736851dd63@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 07:06:39PM +0200, Pekka Enberg wrote:
> Hi Greg,
> 
> On Jan 24, 2008 6:44 PM, Greg KH <greg@kroah.com> wrote:
> > No, that's not the problem.  The code should just be using
> > usb_register_driver() and then doing what it needs to do in the probe()
> > callback, like any other USB driver.
> >
> > By calling usb_find_device() it allows more than one driver to talk to
> > the device at the same time, setting it up for some very bad things to
> > possibly happen to the device.
> >
> > So a simple code change should be all that is needed to properly fix
> > this.
> >
> > If you want, I can make up a patch, just point me at the version you
> > wish me to modify.
> 
> As I already mentioned in private, the code is here:
> 
> http://www.init0.nl/iriverfs-r0.1.0.1-linux-2.6.23.patch.bz2
> 
> It's basically abusing the USB driver stack with a ->probe() function
> that returns -ENODEV and doing device discovery at mount time. That,
> however, is also broken as it assumes there's only one device plugged
> in (we're not passing any device identifier to sys_mount).

By returning -ENODEV, that still allows some other driver or user
through usbfs to come in and start talking to the device, while this
"driver" also touches it.  Not nice.

> So it's not a simple code change at all.

Just create a root directory for every device that is seen in the
probe() function.  That should be pretty simple to do.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZBDAFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZBDAFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZBDAFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:05:15 -0500
Received: from kroah.org ([198.145.64.141]:42719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751134AbZBDAFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:05:14 -0500
Date: Tue, 3 Feb 2009 16:03:42 -0800
From: Greg KH <greg@kroah.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable]  A patch in 2.6.27.9 caused device names to change
Message-ID: <20090204000342.GB22380@kroah.com>
References: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com> <20090203000529.GC9467@kroah.com> <1233672611.11344.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233672611.11344.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 09:50:11AM -0500, Dan Williams wrote:
> On Mon, 2009-02-02 at 16:05 -0800, Greg KH wrote:
> > On Mon, Feb 02, 2009 at 05:02:38PM -0500, Chuck Ebbert wrote:
> > > This patch:
> > > http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.27.9/usb-option-add-pantech-cards.patch;hb=HEAD
> > > 
> > > replaced my wireless adapter's /dev/ttyACM0 interface with three interfaces:
> > > /dev/ttyUSB[012]
> > > 
> > > That broke my ppp connection scripts. And I have to use /dev/ttyUSB1 to connect,
> > > not USB0. Also it looks like Network Manager only knows how to use the first
> > > interface in its auto-connect mode, so people using that also lost their
> > > connections.
> > 
> > Ugh, that sucks.
> > 
> > That is what is also in upstream, so 2.6.29-rc also fails for you?
> > 
> > Dan, what's with replacing working devices with the cdc-acm driver with
> > option device ids?  Is there some reason you did this?
> 
> For a long time we've been operating under the assumption that mobile
> broadband devices should be driven by option and sierra, since those
> drivers had the necessary buffering optimizations to support
> higher-speed mobile broadband devices.

Who is "we" here?  Not me :)

> That was true at least up until 2.6.24.

It all depends on the type of device.  If it says it is a cdc-acm modem,
by all means, let that driver handle it, don't try to bind it to a
different driver (that way lies races and madness...)

> Furthermore, up until this point, I have not seen mobile broadband
> adapters (that aren't cellphones connected via USB) that *are* CDC-ACM
> compliant.  Everything previously has advertised proprietary interfaces,
> some of which are serial ports and some of which are not.

Probably because we never see those devices being reported, because they
"just work" with no interaction from us.

> Plus, are we expected to keep device names stable these days?  cdc-acm
> is the catch-all driver, but if that driver is more "generic" and a
> better driver is found, can we not update IDs just because the device
> name may change?

cdc-acm is the driver for devices that follow the spec and tell the host
computer that they are following the spec.

I'll go dig out and revert this patch, and then propagate it down to the
-stable releases as well...

thanks,

greg k-h

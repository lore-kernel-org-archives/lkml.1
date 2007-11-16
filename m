Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbXKPUsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbXKPUsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXKPUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:48:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41080 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752465AbXKPUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:48:46 -0500
Date: Fri, 16 Nov 2007 15:48:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: David Woodhouse <dwmw2@infradead.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in __device_release_driver
In-Reply-To: <20071116203748.GA11770@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711161548040.4691-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Greg KH wrote:

> On Fri, Nov 16, 2007 at 11:57:28AM -0500, Alan Stern wrote:
> > This patch (as1013) was suggested by David Woodhouse; it fixes a race
> > in the driver core.  If a device is unregistered at the same time as
> > its driver is unloaded, the driver's code pages may be unmapped while
> > the remove method is still running.  The calls to get_driver() and
> > put_driver() were intended to prevent this, but they don't work if the
> > driver's module count has already dropped to 0.
> > 
> > Instead, the patch keeps the device on the driver's list until after
> > the remove method has returned.  This forces the necessary
> > synchronization to occur.
> 
> Is this something that you all feel is worth getting in for 2.6.24?
> Does it fix a regression that just showed up, or is just a bugfix for
> something that people finally realized has always been there?
> 
> Can it wait for 2.6.25 to get some more testing in -mm?

Considering how few people have been affected by it, I'm willing to 
let it wait for 2.6.25.  David Woodhouse may feel differently.

Alan Stern


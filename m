Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbXK2THu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbXK2THu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXK2THm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:07:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37558 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932303AbXK2THl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:07:41 -0500
Date: Thu, 29 Nov 2007 14:07:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       <kirk@faunos.com>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
In-Reply-To: <474F0C8D.3090604@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0711291406460.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Mark Lord wrote:

> Alan Stern wrote:
> > On Thu, 29 Nov 2007, Raymano Garibaldi wrote:
> > 
> >> The feature does work as long as the device remains plugged in and
> >> that is what I have said in my previous postings too. What I'm saying
> >> that should work and worked under 2.6.21 and is not working currently
> >> is the ability to unplug and plug back in the device while the
> >> computer is suspended before resuming without losing the mount.
> > 
> > Okay, guess I misunderstood what you wrote before.
> > 
> > The patch below for 2.6.23 should do what you want (and more besides).  
> > It forces the USB Persist feature to apply to all persist-enabled 
> > devices, whether they were unplugged or not.
> > 
> > There's no chance of this getting accepted into the official kernel in 
> > such a simple form, but at least it will allow you to do what you want.
> > 
> > Alan Stern
> > 
> > 
> > --- 2.6.23/drivers/usb/core/driver.c1	2007-11-29 10:57:36.000000000 -0500
> > +++ 2.6.23/drivers/usb/core/driver.c	2007-11-29 11:01:44.000000000 -0500
> > @@ -1550,6 +1550,9 @@
> >  		if (!(udev->reset_resume && udev->do_remote_wakeup))
> >  			return -EPERM;
> >  	}
> > +
> > +	/* Force all system resumes to be reset-resumes */
> > +	udev->reset_resume = 1;
> >  	return usb_external_resume_device(udev);
> >  }
> ..
> 
> Mmm.. how about a nice sysfs attr that the suspend scripts can write
> that value to as needed ?

Write what value to?  Besides, there already _is_ a sysfs attribute
scripts can use to enable or disable USB-Persist for each device.

Alan Stern


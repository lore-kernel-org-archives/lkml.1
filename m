Return-Path: <linux-kernel-owner+w=401wt.eu-S936543AbZDCQPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936543AbZDCQPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935201AbZDCP7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:59:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935200AbZDCP7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:59:11 -0400
Date: Fri, 3 Apr 2009 08:57:04 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403155704.GA26189@suse.de>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151232.GA21657@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403151232.GA21657@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 04:12:32PM +0100, Matthew Garrett wrote:
> On Fri, Apr 03, 2009 at 08:03:01AM -0700, Greg KH wrote:
> > On Fri, Apr 03, 2009 at 02:57:19PM +0100, Matthew Garrett wrote:
> > > So it's a driver that's useless without a closed source firmware loader, 
> > > either in the form of a Linux userspace application that can't be 
> > > distributed or in the form of Windows?
> > 
> > Hm, I originally thought that as well, but I have a laptop here that
> > doesn't seem to need the firmware code at all (I deleted it and rebooted
> > from poweroff and everything worked fine.)
> > 
> > So it seems it depends on the hardware platform.
> 
> Hmm. What's the USB ID of that one?

USB_DEVICE(0x05c6, 0x9211);

> > > I thought we'd decided that drivers weren't going to be merged in that
> > > case (poulsbow, the original 3945 driver)
> > 
> > We have lots of drivers that rely on firmware that is not in the kernel
> > to work properly, I see this as just the same thing.
> 
> It's not that it relies on firmware - I can get my hands on the firmware 
> easily enough. The issue is that I have no way of loading it without 
> using non-free code, which I think puts it in the same category as 
> Poulsbo and ipw3945 rather than, say, b43.

No, both of those are quite different, they interact with the closed
source bits directly from the kernel, which isn't allowed.  This just
needs the firmware loaded into the device to work at all, much like an
"empty" b43 device would be.

> > And again, I have been assured that the code is going to be distributed
> > soon, and that others are already using the driver successfully.
> 
> Everything I've been able to find suggests that the only people using it 
> are booting Windows first, so your one seems to be the oddity. On the 
> other hand, I'm kind of surprised that we're merging drivers on the 
> promise that code to use them will be available "soon". It seems to end 
> up giving the vendor credit that they don't deserve as yet.

As I did not realize the hardware was shipping yet (my machine is a
pre-production unit), I thought the firmware issue would be resolved by
the time shipments happened.

We want manufacturers to ship early and often, this was just doing that.

Oh, and it was not giving the vendor any credit at all, their original
driver was one of the worse things I had seen in a long time (200 or so
lines, over 300 checkpatch errors, a new record.)  I rewrote it from
scratch because of the mess involved.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762964AbZEGWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762964AbZEGWrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZEGWrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:47:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56295 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750959AbZEGWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:47:04 -0400
Date: Thu, 7 May 2009 18:47:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usbfs, claiming entire usb devices
In-Reply-To: <ac3eb2510905071439j7736711axc729008923435cea@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905071843100.3868-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Kay Sievers wrote:

> >> You have one file per device, and that file has normal unix file
> >> permissions. Userspace can grant access to that file by ownership or
> >> by adding an ACL. What else do we need?
> >
> > We need the ability to prevent the kernel from automatically
> > configuring a device.  We need the ability to prevent kernel drivers
> > from binding to a device before userspace programs get a chance.
> >
> >>  Why would the kernel care who
> >> opened the file, when the one was able to get through the normal file
> >> access check?
> >
> > Access checks can't be used, because programs want to stake their claim
> > to the device (and its file) even before the device has been plugged
> > in.  So there's no file and no ACL to set.
> 
> I see.
> 
> Can't userspace just unbind a possible driver, which is supported by
> libusub? Other such use-cases do that, like the UPS userspace drivers,
> which just unbind the device from a possible in-kernel driver to take
> it over.
> 
> Or is that a specific requirement where things would go wrong when the
> kernel binds to a device first?

You've got it.  Sometimes devices are in a very precarious state (such 
as during a firmware update) and they need to go into a particular 
configuration.  Letting the kernel install some random configuration at 
such times doesn't work.

Similarly, although devices are supposed to be able to switch configs 
at any time, in fact some buggy ones don't allow it.  And while letting 
a kernel driver bind to a device shouldn't cause any narm, with some 
buggy devices it does.

Alan Stern


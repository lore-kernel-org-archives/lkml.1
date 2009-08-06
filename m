Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZHFT5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZHFT5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbZHFT5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:57:05 -0400
Received: from kroah.org ([198.145.64.141]:55326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbZHFT5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:57:03 -0400
Date: Thu, 6 Aug 2009 12:54:28 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: Is anyone maintaining (or even using) usbtmc?
Message-ID: <20090806195428.GA29723@kroah.com>
References: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
 <20090803212015.GC28579@kroah.com>
 <cb0375e10908031449l2005a468v9683eb5a078cf226@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb0375e10908031449l2005a468v9683eb5a078cf226@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:49:09PM -0400, Andrew Lutomirski wrote:
> On Mon, Aug 3, 2009 at 5:20 PM, Greg KH<greg@kroah.com> wrote:
> > On Mon, Aug 03, 2009 at 05:14:56PM -0400, Andrew Lutomirski wrote:
> >> Hi all-
> >>
> >> I'm trying to use usbtmc on an Aglient N9310A (The only TMC device I
> >> have), and it sort of works, but it seems to be both extremely buggy
> >> and missing a good deal of rather important functionality.  Is there
> >> anyone maintaining it?
> >
> > Yes, me.
> >
> >> If the answer is yes, I can describe the bugs (logspam, spurious
> >> errors, delayed messages, inability to read status, etc.) in greater
> >> detail.
> >
> > Please do, but also please use the latest version, in 2.6.30.3, we fixed
> > some bad problems in it recently.
> 
> I am.
> 
> Almost anything I do triggers this:
> 
> usbtmc 3-1:1.0: Unable to read data, error -110
> 
> The easiest way is to write something that wasn't a query and then try
> to read.  Of course, the read should fail, but there's no reason it
> should spam the logs.

Ok, care to send a patch reducing the error level of the message?

> On occasion, sending garbage to the device will cause even a
> subsequent USBTMC_IOCTL_CLEAR to fail with ETIMEDOUT.  (Maybe I wanted
> USBTMC_IOCTL_ABORT_BULK_IN?  That seems wrong, though, since
> presumably the driver should manage pending Bulk-IN requests on its
> own.)

Possibly, although I don't know the protocol for what should happen when
sending garbage to devices, except that it is probably undefined :)

> On other occasions (usually triggered by sending a garbage command,
> but, when this happens, the problem persists across several messages),
> every response will be delayed.  That is, if I send a query, I get
> back the previous query's answer or ETIMEDOUT if the previous command
> wasn't a query.  This persists across closing and reopening the
> device.
> 
> Sometimes write() fails with ETIMEDOUT.  This failure happens with no
> perceivable delay and I have no idea why.

Device problems?

> An ioctl for GET_CAPABILITIES would be nice, but is not mandatory.

What's wrong with the sysfs file for this instead?

> Finally, I see no way to read the USB488 status byte or detect a
> status interrupt.

Hm, is this in the spec somewhere that I missed?  Patches are always
welcome.

thanks,

greg k-h

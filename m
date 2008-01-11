Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbYAKRP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbYAKRP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYAKRPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:15:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37846 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbYAKRPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:15:47 -0500
Date: Fri, 11 Jan 2008 09:10:06 -0800
From: Greg KH <greg@kroah.com>
To: mgross <640e9920@gmail.com>
Cc: Paulo Marques <pmarques@grupopie.com>, Xiaofan Chen <xiaofanc@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [RFC] libusb / in-kernel usb driver criteria
Message-ID: <20080111171006.GA6718@kroah.com>
References: <20071229193409.GA20188@mgross-t43> <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org> <20071230035349.GA4741@mgross-t43> <a276da400712292052h5808c33apd5269e773edfb592@mail.gmail.com> <477BED13.4060403@grupopie.com> <20080103230855.GA5892@mgross-t43>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103230855.GA5892@mgross-t43>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 03:08:55PM -0800, mgross wrote:
> On Wed, Jan 02, 2008 at 07:59:15PM +0000, Paulo Marques wrote:
> > Xiaofan Chen wrote:
> >> On Dec 30, 2007 11:53 AM, mgross <640e9920@gmail.com> wrote:
> >>> [...]
> >>> What is the linux-usb policies on new drivers that could be
> >>> implemented in user space?  When does a kernel driver make sense over
> >>> a libusb one?

Good question.

> >> That would be interesting to know.
> >
> > I myself have been faced with this question before, and I think we should 
> > try to clarify this by adding a document with some guidelines to 
> > Documentation/usb.
> >
> > So, to get the ball rolling, here are some factors that IMHO help decide in 
> > which side to implement a driver:
> >
> >  - if the driver ties a hardware device to an existing in-kernel interface 
> > (network, block, serial, bluetooth, video4linux, etc.), it should probably 
> > be implemented in-kernel.
> 
> Agreed, I think this is clear.

Yes, this the primary decision point, everything after this depends on
lots of variables :)

> >  - on the other hand, if the driver doesn't use an existing kernel 
> > interface and creates a new user-visible interface that is going to be used 
> > by a single userspace application, it should probably be done in userspace.
> >
> 
> To me this is still grey, and comes down to opinions of style.  I
> happen to like the way code looks when things are split up into
> drivers (that know a lot about the hardware and protects it from data
> that will turn it into a brick) and application code that talks to the
> interface defined by the driver.
> 
> The libusb based applications I've seen tend to be quite convoluted
> and do a poor job of separating the USB protocol from the application
> protocol for talking to the device.
> 
> I don't think there is a clear way to define when to do a kernel
> driver vrs just use a libusb thing, other than if no one does a kernel
> driver for a device then users are stuck with the libusb applications.
> 
> If someone steps up and does one and is willing to support it, then to
> me its like, "whatever" add the driver. 

Agreed.  It all depends on the situation, we have kernel drivers for
devices that can be done in userspace, but not as cleanly or nicely, and
so, they stay as kernel drivers.

In the end, it comes down to individual cases, so let's handle them at
that level, it's easier that way.

thanks,

greg k-h

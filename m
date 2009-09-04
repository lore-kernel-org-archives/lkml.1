Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZIDPMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZIDPMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZIDPMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:12:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33171 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756778AbZIDPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:12:33 -0400
Date: Fri, 4 Sep 2009 11:12:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@linux.intel.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: WARNINGs in usb-serial.c
In-Reply-To: <20090904164824.391876b3@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.0909041109480.3204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009, Alan Cox wrote:

> On Fri, 4 Sep 2009 10:17:30 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Fri, 4 Sep 2009, Miklos Szeredi wrote:
> > 
> > > On Thu, 3 Sep 2009, Greg KH wrote:
> > > > On Thu, Sep 03, 2009 at 04:13:34PM +0200, Miklos Szeredi wrote:
> > > > > I get the following warnings in 2.6.31-rc.  A lot of them:
> > > > > 
> > > > > WARNING: at drivers/usb/serial/usb-serial.c:414
> > > > > serial_write_room+0x59/0x6e [usbserial]() WARNING: at
> > > > > drivers/usb/serial/usb-serial.c:401 serial_write+0x77/0x9d
> > > > > [usbserial]()
> > > > > 
> > > > > This is a huawei-3565 modem.
> > > > > 
> > > > > The messages don't seem to hurt, but there's lot of trouble
> > > > > with this gadget.  Sometimes it just doesn't work after a while
> > > > > and a reboot is needed.  Sometimes it hangs the kernel after
> > > > > suspend, etc.  Not sure if this is related to the warnings...
> > > > 
> > > > {sigh}
> > > > 
> > > > The tty layer changes are being a pain here :(
> > > > 
> > > > Alan Stern posted a set of patches to the linux-usb list to
> > > > hopefully address stuff like this, is there any way you could
> > > > test them out to see if they help or not?
> > > 
> > > Nope, it doesn't seem to help.  Still got the same warnings with the
> > > patched kernel (latest git + ghk tree + usbserial patches).
> > 
> > What were you doing when these warnings appeared?
> 
> The usual way to get it was
> 
> 	close
> 		users = 0
> 		ldisc processing
> 		echo
> 		write room
> 			hey we are closed
> 				Spew
> 
> I suspect the actual check in write_room is now simply bogus with it
> all being refcounted (the ldisc will hold a tty kref at that point)

That makes sense.  It would mean that all those

	WARN_ON(!port->port.count);

lines in usb-serial.c should simply be removed.  Miklos, do you want to 
try removing them?

Alan Stern


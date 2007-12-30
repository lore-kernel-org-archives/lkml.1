Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbXL3E37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbXL3E37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 23:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXL3E3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 23:29:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:60273 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbXL3E3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 23:29:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DV10itsXk22FvkI29jJ9+tlaDmgAZB36TTHzCaa4P9tLstavkfeTXDe3rvnsyXdRikdJ6oOL2Rvc4JskM/lZ5l7aInGui13URxwBd9xX6GjxbPt5Je+AxYoQw11g2nW5V1tF3tBY1Cp9zlXU8qUgOd+rjkUohAQpqD2CEuqY2u8=
Date: Sat, 29 Dec 2007 20:29:39 -0800
From: mgross <640e9920@gmail.com>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [RFC] USB driver for talking to the Microchip PIC18 boot loader
Message-ID: <20071230042939.GB4741@mgross-t43>
References: <20071229193409.GA20188@mgross-t43> <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org> <a276da400712291840m7d90d6fr5d80f21a04a1c1b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a276da400712291840m7d90d6fr5d80f21a04a1c1b3@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 10:40:45AM +0800, Xiaofan Chen wrote:
> On Dec 30, 2007 6:15 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sat, 29 Dec 2007, mgross wrote:
> >
> > > I'm playing around with a PIC based project at home (not an Intel
> > > activity) and found I needed a usb driver to talk to the boot loader
> > > so I can program my USB Bitwhacker with new custom firmware.  The
> > > following adds the pic18bl driver to the kernel.  Its pretty simple
> > > and is somewhat based on bits of a libusb driver that does some of
> > > what this driver does.
> > >
> > > What do you think?
> >
> > Not to detract from your driver, but would it be possible to do the
> > whole thing in userspace using libusb?  Maybe by extending the driver
> > you mentioned?
> >
> 
> The existing libusb based application works fine for PICDEM FS USB
> or those based on it (like the Bitwhacker the OP is using).

The device ID's are different 0x000C in ldusb.c vrs 0x000b in the
driver I just posted.

Have you read my patch yet?

> 
> Please do not add it to the kernel. There are libusb based application
> for both the bootloader and the demo application and both are working
> fine under Linux (along with Windows and I am trying to get FreeBSD
> working).

The libusb based FW loader http://www.internetking.org/fsusb/ program
is nasty and didn't work on one of my systems, so I refactored it into
a kernel driver and python program.

> 
> Last time the demo application has been added to the ldusb and
> I think it is not a good idea. But since then I've added patches to
> the existing libusb application.
> 
> Relevant discussion in thread
> '[PATCH 70/78] USB: add picdem device to ldusb'
> http://marc.info/?t=117770076400003&r=1&w=2
> 
> So please do not do this again. It is not a problem for the libusb
> based applications after the patches but it is really not necessary.

Why not?

There are a lot of redundant things in the world.  Linux is not
necessary if you really want to take this argument to its extreme.

> 
> Original libusb based application for the bootloader:
> http://www.internetking.org/fsusb/

Yup thats the code.  I found it way complex to read and felt a simple
kernel driver and simple python program much nicer to my
sensibilities.

We are getting quickly getting into a fuzzy/ opinion, area on this
thread.  Is there a technical angle we can discuss?  My LOC count of
the kernel driver and boot loader is smaller than the fsusb thing.
Also, with a kernel driver and a python lib, a GUI based boot loader
utility can be had with little effort.
 
> Original libusb based application for the Demo which
> also includes my patch for libusb-win32.
> http://www.varxec.net/picdem_fs_usb/
> 
> Updated Patches to detach the kernel driver for both
> the bootloader and Demo application.
> http://forum.microchip.com/tm.aspx?m=106426
> 
> Xiaofan Chen
> http://mcuee.blogspot.com

You blogging about me already?
I wont comment on that.

--mgross



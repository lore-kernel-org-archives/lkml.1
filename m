Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbZHRRGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbZHRRGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759420AbZHRRGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:06:52 -0400
Received: from ppp-152-18.adsl.restena.lu ([158.64.152.18]:60173 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383AbZHRRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:06:52 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 13:06:51 EDT
Date: Tue, 18 Aug 2009 19:00:16 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090818190016.73ce53de@neptune.home>
In-Reply-To: <20090810192954.GA11651@suse.de>
References: <20090808194733.38406075@neptune.home>
 <Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
 <20090810154402.GA7701@kroah.com>
 <20090810191822.26370810@neptune.home>
 <20090810181306.GA24989@kroah.com>
 <20090810203501.4d57aa5b@neptune.home>
 <20090810205115.6871239d@neptune.home>
 <20090810192954.GA11651@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Were you able to reproduce this with a FTDI usbserial device?


I just had a short look with 2.6.31-rc6, it crashes harder... once
kernel did panic with general protection fault after reporting
  tty_port_close_start: count=-1
The second time id started output of an Oops but only half of the first
line ever showed up on screen (Intel KMS).

Note: this was with just usbserial.ko and ftdi_sio.ko rebuilt with
CONFIG_DEBUG_INFO=y in the hope to find out what did access a bad
pointer. (make CONFIG_DEBUG_INFO=y drivers/usb/serial/$module.ko)

Will retry now with a fresh compile with CONFIG_DEBUG_INFO enabled for
whole kernel and see if I can get better information, eventually
switching to vesa framebuffer in case the partial output happens again.

This pretty much looks like unbalanced ref-count...

Thanks,
Bruno

On Mon, 10 August 2009 Greg KH <gregkh@suse.de> wrote:
> > > I have not tried yet with a different USB serial device but will
> > > do so soon to see if I can reproduce it there. (the other
> > > USBSerial device I have is: 067b:2303 Prolific Technology, Inc.
> > > PL2303 Serial Port)
> > 
> > I can't reproduce with this one.
> > 
> > Similar setup, but instead of SheevaPlug (with it's kernel started
> > with console=ttyS0,115200 + agetty run by init) I just started
> > agetty (same parameters) on a x86 box with uart serial port (e.g.
> > that x86 kernel does not have console kernel parameter) and
> > connected that one via NullModem cable to the Prolific USBSerial
> > converter.
> > 
> > In this case, no matter how often I pull the USBSerial converter
> > there is no Oops.
> > 
> > So it must be something that FTDI driver does differently from e.g.
> > Prolific one.
> 
> Ok, thanks, I'll dig through my big box of usb devices to try to find
> a ftdi device, I was testing this out on a pl2303 device, which is
> why I couldn't reproduce it it seems.

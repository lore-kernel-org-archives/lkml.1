Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZHJSfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZHJSfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZHJSfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:35:22 -0400
Received: from ppp-152-125.adsl.restena.lu ([158.64.152.125]:42331 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZHJSfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:35:22 -0400
Date: Mon, 10 Aug 2009 20:35:01 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090810203501.4d57aa5b@neptune.home>
In-Reply-To: <20090810181306.GA24989@kroah.com>
References: <20090808194733.38406075@neptune.home>
	<Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
	<20090810154402.GA7701@kroah.com>
	<20090810191822.26370810@neptune.home>
	<20090810181306.GA24989@kroah.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 August 2009 Greg KH <greg@kroah.com> wrote:
> On Mon, Aug 10, 2009 at 07:18:22PM +0200, Bruno Prémont wrote:
> > On Mon, 10 August 2009 Greg KH <greg@kroah.com> wrote:
> > > On Mon, Aug 10, 2009 at 11:18:29AM -0400, Alan Stern wrote:
> > > > On Sat, 8 Aug 2009, Bruno Prémont wrote:
> > > > 
> > > > > I tried bisecting this but bisect did end up on a fully
> > > > > unrelated commit (which is not even being compiled into my
> > > > > kernel). Possibly the failed bisect could be related to
> > > > > mis-classified kernel panic/hang while pulling the USB cable
> > > > > (there were two such panics for the whole iteration)?
> > > > > 
> > > > > There are quite a few patches touching tty, ttyUSB and friends
> > > > > between rc4 and now so pretty hard to guess on the correct
> > > > > one.
> > > > > 
> > > > > The oops always happens when I disconnect the USB serial
> > > > > console (here the one built into Marvell SheevaPlug) while
> > > > > having minicom connected to it.
> > > > > During the bisection for the last few bad iterations minicom
> > > > > got killed (segfault), the bad ones on the iteration left a
> > > > > minicom zombie in 'D' state.
> 
> Ok, a few questions.
> 
> Are you pulling the device out when you have a console attached to the
> device, or just a "normal" minicom connection with it?  I can't seem
> to duplicate this here at the moment for some reason :(
> 
> thanks,
> 
> greg k-h
> 

The SheevaPlug has a getty running on ttyS0 (agetty 115200 ttyS0 vt100).
That ttyS0 is exported via the FTDI USB to Serial+JTag converter.

On the laptop side (where the kernel Oopses) I see /dev/ttyUSB0 (which
I instruct minicom to use via symlink to
/dev/serial/by-id/usb-FTDI_SheevaPlug_JTAGKey_FT2232D_B_FTS55QK6-if01-port0
 -- minicom is limited to 63byte length for path to tty device)

I run minicom with the following parameters:
  minicom -o -c on sheeva

/etc/minicom/minirc.sheeva
  pu port             /etc/minicom/tty-sheeva
  pu rtscts           No

That is 115200 8N1, with neither hardware nor software flow control.

I'm pulling the USB cable while minicom is running and agetty on the
other side is waiting for password input. (pulling the USB cable is
too easy - and same effect is obtained when pulling power from the
SheevaPlug)


I have not tried yet with a different USB serial device but will do so
soon to see if I can reproduce it there. (the other USBSerial device I
have is: 067b:2303 Prolific Technology, Inc. PL2303 Serial Port)

thanks,
Bruno

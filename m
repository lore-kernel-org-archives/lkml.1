Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbXDYAQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbXDYAQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXDYAQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:16:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37955 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbXDYAQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:16:32 -0400
Date: Tue, 24 Apr 2007 17:13:56 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Re: regression with gammu on 2.6.21-rc7
Message-ID: <20070425001356.GB1183@kroah.com>
References: <20070420085853.GA5594@erig.dyndns.org> <20070423054717.GB17997@kroah.com> <20070423081022.GA25694@erig.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423081022.GA25694@erig.dyndns.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 10:10:22AM +0200, Wolfgang Erig wrote:
> Hello Greg,

Please don't take me out of the cc:, otherwise I might mist this (as I
did...)

> On Sun, Apr 22, 2007 at 10:47:17PM -0700, Greg KH wrote:
> > On Fri, Apr 20, 2007 at 10:58:53AM +0200, Wolfgang Erig wrote:
> > > Hello,
> > > 
> > > I have a regression with 2.6.21-rc7-g80d74d51.
> > > The utility "gammu" to talk to my mobile does not work anymore.
> > > With 2.6.20 gammu runs fine.
> > > 
> > > Distribution is the latest Debian/testing
> > > 
> > > Wolfgang
> > > 
> > > $ gammu --backup backup
> > > Press Ctrl+C to break...
> > > I/O possible
> the problem is here because gammu stops working.
> Maybe a problem in gammu, but with 2.6.20 gammu works fine.
> > > $ uname -a
> > > Linux max 2.6.21-rc7-g80d74d51 #9 SMP Wed Apr 18 21:41:41 CEST 2007 i686 GNU/Linux
> > > $ tail messages 
> > > Apr 20 08:04:36 max kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
> > > Apr 20 08:04:36 max kernel: extern: link up, 100Mbps, full-duplex, lpa 0x45E1
> > > Apr 20 08:04:36 max kernel: intern:  setting half-duplex.
> > > Apr 20 08:09:02 max kernel: usb 2-2: USB disconnect, address 3
> > > Apr 20 08:09:02 max kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> > > Apr 20 08:09:02 max kernel: pl2303 2-2:1.0: device disconnected
> > > Apr 20 08:10:24 max kernel: usb 2-2: new full speed USB device using uhci_hcd and address 4
> > > Apr 20 08:10:25 max kernel: usb 2-2: configuration #1 chosen from 1 choice
> > > Apr 20 08:10:25 max kernel: pl2303 2-2:1.0: pl2303 converter detected
> > > Apr 20 08:10:25 max kernel: usb 2-2: pl2303 converter now attached to ttyUSB0
> > 
> > That looks ok, I'm guessing you yanked it out and then back in?
> Yes.
> This is included only to see which device is connected.
> > Or is the problem that the device was removed?
> No, no problem with removal.
> I see no hint for a problem in the usb-layer.

I don't see any problems here.

If you enable debugging in the pl2303 driver, do you get any errors?
You can do this by:
	modprobe pl2303 debug=1
or if the module is built in or already loaded:
	echo 1 > /sys/modules/pl2303/parameters/debug


Also, if you know how to use git, doing a 'git bisect' to try to track
down the problem commit would be very helpful.

thanks,

greg k-h

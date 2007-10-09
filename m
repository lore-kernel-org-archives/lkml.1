Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbXJIGnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbXJIGnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbXJIGnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:43:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:38581 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbXJIGnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:43:41 -0400
Subject: Re: OHCI root_port_reset() deadly loop...
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Brownell <david-b@pacbell.net>
Cc: greg@kroah.com, davem@davemloft.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071009050019.C6C6023718A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071009031049.GD14127@kroah.com>
	 <20071008.201653.43030513.davem@davemloft.net>
	 <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <20071008.204236.92016616.davem@davemloft.net>
	 <20071009043909.GA4940@kroah.com>
	 <20071009050019.C6C6023718A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 16:43:04 +1000
Message-Id: <1191912184.6355.66.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-08 at 22:00 -0700, David Brownell wrote:
> > > > The old /etc/hotplug/usb.rc script made sure to load those modules
> > > > in the correct order:  EHCI first.
> > > 
> > > I expected to find something cute attempting to handle this under
> > > /etc/udev, I have failed so far :-)
> >
> > No, nothing cute in udev itself, but it seems that all distros that I
> > know of have a "load these modules now" type setting in their init
> > scripts that can be used here.
> >
> > I can't think of a way to enforce this load order on the modules
> > themselves due to the fact that OHCI might not even be needed for EHCI
> > devices on UHCI (Intel) based chipsets :(
> 
> Assuming PCI is present, /sys/bus/pci/devices/*/class can tell
> if EHCI is present (0x0c0320) ... if so, load that driver.
> Then repeat for OHCI (0x0c0310) and UHCI (0x0c0300).

That will not work for all of the non-PCI implementations though.

Ben.



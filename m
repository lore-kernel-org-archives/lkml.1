Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZCHQ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZCHQ6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZCHQ6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:58:35 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40370 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752845AbZCHQ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:58:34 -0400
Date: Sun, 8 Mar 2009 12:58:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
In-Reply-To: <1236528558.11774.50.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.44L0.0903081243100.5243-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Mar 2009, Maxim Levitsky wrote:

> > No, adding a dependency won't work because it is valid to load 
> > uhci-hcd without ehci-hcd.  The only time a problem occurs is if you 
> > load both of them in the wrong order.  (And in fact it's pretty rare 
> > for that to cause a real problem -- mostly you just get some annoying 
> > messages in the log.)
> But since it can cause a problem, this has to be somehow automatically
> fixed isn't it?

Can it cause a problem?  I'm not so sure -- it depends on what you mean 
by "problem".  One person complained forcefully just because he didn't 
like all the extra "disconnect" messages in the system log, even though 
everything worked perfectly.

> For example how to I ensure the correct order with udev?

You can't.  But you can add rules to /etc/modprobe.conf to insure that 
ehci-hcd is always loaded before uhci-hcd.

> > CONFIG_USB_EHCI_ROOT_HUB_TT shouldn't make any difference at all.  
> > That setting matters only for hardware using the ARC/TDI design, which
> > is not present in your Intel chipset.  Likewise, provided ehci-hcd is
> > loaded first, it shouldn't make any difference whether uhci-hcd is
> > loaded or not.
> Well, I retest this.
> But it seems to work

Best would be if you could send two usbmon traces, one showing the 
problem and one showing what happens when uhci-hcd isn't loaded but 
everything else is the same.  For each test, plug in the printer's USB 
cable after starting the trace.

And don't try to confuse matters by querying the printer status while 
reloading its firmware.

Alan Stern


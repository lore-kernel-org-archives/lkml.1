Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZCIQPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZCIQPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZCIQPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:15:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36822 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752482AbZCIQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:15:31 -0400
Date: Mon, 9 Mar 2009 12:15:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
In-Reply-To: <1236614253.17511.5.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.44L0.0903091211480.4008-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Maxim Levitsky wrote:

> > Is your printer connected directly to the computer, or does it go 
> > through a hub?  (If it is connected directly then EHCI_TT_NEWSCHED 
> > should not affect it at all.)
> > 
> > If it does go through a hub, does it behave better when you attach it 
> > directly?
> > 
> > Alan Stern
> > 
> No, it is connected directly.
> Just tried 'bad' driver, and firmware upload failed
> 
> Do you mean that CONFIG_USB_EHCI_TT_NEWSCHED doesn't affect the driver
> at all when no hub is presented?

That's right.  Transaction Translators (TTs) live inside hubs.  If you 
don't use a hub then the TT code never runs.

> Btw, at least according to lsusb -t, there are no internal hubs in the
> printer.

What does /proc/bus/usb/devices say?

> But it can be a coincidence, it seems that with 'bad' driver printer
> works 'better' to as it failed back few days ago much more often, maybe
> cable is bad, don't know, but according to the web these printers
> 1018/1020.. have usb problems, there is even a readme for that in
> foo2zjz  
> 
> I try to use the 'good' driver 
> (without CONFIG_USB_EHCI_TT_NEWSCHED) for some time.

Please don't forget to collect usbmon traces when the problem occurs.

Alan Stern


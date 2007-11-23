Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbXKWCvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbXKWCvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 21:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXKWCvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 21:51:32 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4574 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752158AbXKWCvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 21:51:31 -0500
Date: Thu, 22 Nov 2007 21:51:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Marin Mitov <mitov@issp.bas.bg>
cc: "Kirill A. Shutemov" <k.shutemov@velesys.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] 2.6.24-rc3-mm1: usb mouse doesn't work
In-Reply-To: <200711221941.44646.mitov@issp.bas.bg>
Message-ID: <Pine.LNX.4.44L0.0711222148590.5327-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007, Marin Mitov wrote:

> > > > I've had some strangenesses with USB lately.  Sometimes running `lsusb'
> > > > makes the USB system notice a newly attached device.
> > >
> > > No. But I have new messages in dmesg:
> > >
> > > uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> > > uhci_hcd 0000:00:1d.2: FGR not stopped yet!
> > > uhci_hcd 0000:00:1d.1: FGR not stopped yet!
> > > uhci_hcd 0000:00:1d.0: FGR not stopped yet!
> > >
> > > > Is that "FGR not stopped yet!" messgae new behaviour?
> > >
> > > It is a new message since 2.6.24-rc3. I have never try -mm tree before.
> >
> > These messages could indicate a timing problem.  You can see the code
> > that writes the messages near the end of wakeup_rh() in
> > drivers/usb/host/uhci-hcd.c.
> >
> > The message gets written if the controller hardware hasn't turned off a
> > particular bit after a 4-us delay.  If the udelay() function wasn't
> > working right, it could cause this problem.
> 
> udelay() _is_ OK for 2.6.24-rc3, so it is not the cause of the problem

But is it OK for 2.6.24-rc3-mm1?  Kirill said specifically that 
2.6.24-rc3 does not display the message but 2.6.24-rc3-mm1 does.

Alan Stern


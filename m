Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZLBP6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZLBP6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZLBP63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:58:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60053 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754273AbZLBP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:58:27 -0500
Date: Wed, 2 Dec 2009 10:58:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912020952.09354.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912021037420.11361-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Ondrej Zary wrote:

> It shows "prev is NULL, qh=f6581080, ehci->async=f6581000".
> 
> The problem is that activating usbmon causes the problem to disappear. No errors
> in maybe 15 attempts. It appeared on 2nd attempt after unloading usbmon.

Nevertheless, the usbmon output might be useful.  Try going through a 
couple of cycles with usbmon installed, then unload usbmon and create a 
crash.

Also, try adding some more debugging output (and let's hope it doesn't
also make the problem disappear).  In start_unlink_async(), just before
your "after:" label, add

	ehci_info(ehci, "unlink qh %p %p\n", qh, qh->qh_next);

In qh_link_async(), just after the wmb(), add

	ehci_info(ehci, "link qh %p %p\n", qh, qh->qh_next);

In end_unlink_async(), just after the iaa_watchdog_done(ehci), add

	ehci_info(ehci, "end unlink qh %p %p\n", qh, qh->next);

And in qh_make(), just before the end, add

	ehci_info(ehci, "create qh %p, dev %s, ep %x\n",
		qh, urb->dev->devpath, urb->ep->desc.bEndpointAddress);

Alan Stern


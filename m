Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbXGaPEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbXGaPEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761425AbXGaPEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:04:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54904 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754301AbXGaPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:04:23 -0400
Date: Tue, 31 Jul 2007 11:04:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Engraf <david.engraf@netcom.eu>
cc: linux-kernel@vger.kernel.org, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <gregkh@suse.de>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
In-Reply-To: <46AEF347.9030007@netcom.eu>
Message-ID: <Pine.LNX.4.44L0.0707311058470.3520-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, David Engraf wrote:

> When CONFIG_USB_UHCI_HCD, CONFIG_USB_OHCI_HCD or CONFIG_USB_EHCI_HCD is
> not configured we don't need to call the quirk_usb_handoff_xxxx function
> in driver/usb/host/pci_quiks.c.
> 
> I think the kernel shouldn't take the control over the usb controller
> when we don't have the driver for it,
> so with this patch the kernel takes the control only when the driver is
> configured.

Have you found a system where this really improves behavior or is it 
just theoretical?

There _is_ a theoretical reason for running the handoff routines even 
when the corresponding driver isn't configured.  Namely, at startup the 
controller will be in some undetermined state as a result of usage by 
the firmware.  Resetting it to a known idle state is a good idea.

Bear in mind that on some systems, not performing the handoff has
caused interrupt storms during startup.

Alan Stern


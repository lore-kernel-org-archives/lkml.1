Return-Path: <linux-kernel-owner+w=401wt.eu-S934778AbYEUOmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbYEUOmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYEUOmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:42:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54064 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752383AbYEUOmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:42:04 -0400
Date: Wed, 21 May 2008 10:42:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Vrabel <david.vrabel@csr.com>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <lchiquitto@novell.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
In-Reply-To: <483431BE.7090707@csr.com>
Message-ID: <Pine.LNX.4.44L0.0805211040160.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, David Vrabel wrote:

> Alan Stern wrote:
> > 
> > The functions you are worried about (usb_hcd_link_urb_to_ep and 
> > usb_hcd_unlink_urb_from_ep) are documented as requiring that interrupts 
> > be disabled by their callers.  This patch isn't needed.
> 
> This requirement is the only reason the whci-hcd driver disables
> interrupts.  Removing this requirement would reduce the time that
> interrupts are disabled in the whci-hcd driver.

That doesn't sound like a valid approach.  If you don't disable
interrupts then you aren't protected against an interrupt handler
submitting an URB and accessing your data structures while whci-hcd is
in the middle of updating them.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbXHAUVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbXHAUVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXHAUVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:21:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXHAUVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:21:46 -0400
Date: Wed, 1 Aug 2007 13:23:47 -0700
From: Greg KH <gregkh@suse.de>
To: David Engraf <david.engraf@netcom.eu>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
	we the driver is configured
Message-ID: <20070801202347.GC11551@suse.de>
References: <Pine.LNX.4.44L0.0707311058470.3520-100000@iolanthe.rowland.org> <46B03078.5040305@netcom.eu> <46B03468.3010307@netcom.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B03468.3010307@netcom.eu>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 09:21:12AM +0200, David Engraf wrote:
> At the moment I have a Jetway/VIA Mainboard which seems to have a
> problem with the handoff.
> Evenwhen I wait about 20 seconds the EHCI_USBLEGSUP_BIOS flag is not
> cleared. I think this is a BIOS
> bug and I will have to talk to Jetway/VIA.

This sounds like a BIOS bug.

> On the other hand, I don't need the EHCI controller in my kernel, so I
> think the kernel shouldn't take the
> handover for the EHCI controller like other OS which do not have an usb
> driver and so don't know that
> there is a EHCI_USBLEGSUP_BIOS flag which should be cleared.

We need to do this early to handle a wide range of machines that do very
nasty things if we do not grab the device as early as possible.  Even if
we do not ever get around to loading that usb driver.

Yeah, hardware sucks at times :(

thanks,

greg k-h

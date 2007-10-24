Return-Path: <linux-kernel-owner+w=401wt.eu-S1765197AbXJXRBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765197AbXJXRBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762312AbXJXQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:52:12 -0400
Received: from iabervon.org ([66.92.72.58]:60133 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762578AbXJXQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:52:09 -0400
Date: Wed, 24 Oct 2007 12:52:07 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, jeff@garzik.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 0/4]: Resolve MSI vs. INTX_DISABLE quirks.
In-Reply-To: <20071023.220622.68038077.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710241234210.32497@iabervon.org>
References: <20071023.195108.69018458.davem@davemloft.net>
 <Pine.LNX.4.64.0710240046220.32497@iabervon.org> <20071023.220622.68038077.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, David Miller wrote:

> From: Daniel Barkalow <barkalow@iabervon.org>
> Date: Wed, 24 Oct 2007 00:58:45 -0400 (EDT)
> 
> > I'm not sure all of the pci_intx() calls in msi.c should be skipped when 
> > the quirk applies; I think some of them might be there so that the legacy 
> > interrupt won't be delivered while MSI is turned off (since the handler 
> > isn't listening for the legacy interrupts). I'd guess this would cause 
> > people to have their MSI-capable device kill their non-MSI-capable device 
> > when they restore their laptop (and the shared interrupt fires and gets 
> > stuck at just the wrong time). No idea if this is a real concern, but I'm 
> > pretty sure that not all of those calls are recent.
> 
> I don't think it's a real concern.

Okay, good. As long as someone more clueful than me has thought about it, 
because I couldn't tell off hand.

> > There's a couple of ATA drivers that look like they might be trying to 
> > work around the same bug, but it's a bit hard to tell. It might be good to 
> > have them use the quirk (or set the flag) because it's cleaner.
> 
> I noticed these cases as well, and I would hope that Jeff would help
> out here using the infrastructure my patches created.

Or coordinate with someone with the quirky hardware, yes.

	-Daniel
*This .sig left intentionally blank*

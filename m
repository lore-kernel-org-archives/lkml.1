Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXJSRsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXJSRsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762849AbXJSRsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:48:43 -0400
Received: from iabervon.org ([66.92.72.58]:40169 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758676AbXJSRsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:48:43 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 13:48:42 EDT
Date: Fri, 19 Oct 2007 13:42:00 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: David Miller <davem@davemloft.net>
cc: Shane.Huang@amd.com, gregkh@suse.de, htejun@gmail.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Henry.Su@amd.com, Libin.Yang@amd.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
In-Reply-To: <20071018.044611.21595530.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710191300530.32497@iabervon.org>
References: <20071018.031957.104033396.davem@davemloft.net>
 <5CAB7B5D6F8AB84AA868A46B47A507055D8C67@sshaexmb1.amd.com>
 <20071018.044611.21595530.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007, David Miller wrote:

> From: "Shane Huang" <Shane.Huang@amd.com>
> Date: Thu, 18 Oct 2007 18:37:59 +0800
> 
> > Hi Miller:
> > 
> > Thank you for your response.
> > 
> > The reason why MSIs of these northbridges do not work is still under
> > further debug, we are NOT able to tell its hardware issue or software
> > issue at this  time. But enablement of them will lead to the OS
> > installation failure in many distributions like openSUSE, Ubuntu etc:
> > https://bugzilla.novell.com/show_bug.cgi?id=302016
> > 
> > So we have to disable them firstly before we find out the root cause,
> > maybe they are just workarounds.
> 
> This logic seems backwards, to me.  "shoot first, ask questions later"
> To me this it not how to approach this problem.
> 
> Once you turn MSI off, there is next to no incentive to fix the
> problem because users aren't running into it any longer.
> 
> The only two devices in that bug report which should be using MSI
> would be the SATA controller and the broadcom ethernet NIC.  And by
> the failed bootup logs provided by the user the problem is clearly
> with the SATA controller.

And the same SATA controller could show up behind a different northbridge. 
It would be unfortunate to hit the same device bug independantly on each 
system and work around it by doing something that won't help the next 
user.

> One common problem we're finding is that some devices have a hardware
> bug where setting INTX_DISABLE in the PCI COMMAND register masks MSI
> interrupts too.
> 
> I mention this because the user in that report mentions that the
> kernel upgrade causes the failure, and one thing we started doing not
> too long ago was to set the INTX_DISABLE bit when MSI is enabled for a
> device.
> 
> So maybe this SATA controller has this problem too.  It is easy to
> test, simply comment out all of the pci_intx() function calls in
> drivers/pci/msi.c and perform a test boot with MSI enabled.

Have we gotten around to having a device quirk for this? I bet it won't be 
too long before we see a system where the SATA controller doesn't work 
with INTX disabled and the ethernet controller doesn't work with it 
enabled, since we've seen devices with each of these bugs.

	-Daniel
*This .sig left intentionally blank*

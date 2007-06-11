Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbXFKRPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbXFKRPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXFKRPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:15:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXFKRPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:15:09 -0400
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de
Subject: Re: [RFC] Runtime allocation of PCI resources
References: <20070611165112.GA30272@srcf.ucam.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 Jun 2007 20:11:24 +0200
In-Reply-To: <20070611165112.GA30272@srcf.ucam.org>
Message-ID: <p73d502uzsj.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> BIOS authors don't always program all the features of hardware. This is 
> often the case for Intel IDE controllers, which are usually able to run 
> in AHCI mode but are rarely configured to do so. Reprogramming them is 
> easy enough other than the requirement for some MMIO space. If the BIOS 
> hasn't allocated this, it's necessary for us to do so manually.

Traditionally we've had bad experiences forcing hardware to do something
the BIOS didn't consider. e.g. occasionally the BIOS has good reasons
to not allow it; maybe it knows about some errata or other problem
the kernel doesn't. 

If you do this then don't make it default at least, but only allow
to force it use an option.
 
> This patch simply attempts to find some free address space and allocate 
> it. The function is designed to be called after the rest of the 
> resources have been allocated in order to avoid colliding with other 
> devices.
> 
> This seems to work fine on x86, but I'm happy to admit that I know 
> little about the intricacies of how PCI is implemented elsewhere. Is 
> this approach valid in the general case? I'm also working on the 
> assumption that the firmware will program hotplug PCI hardware in a way 
> that isn't going to end up colliding with this. Anyway, any 
> thoughts/comments?

I tried something similar some time ago for the IOMMU aperture.
It turned out that some systems put something into the e820 holes
and didn't boot anymore if you put something else in there.
Your resource allocation will just do that.

You might be lucky because your resources are typically
small (IOMMU aperture was 64+MB) or you might not.

These problems are unfortunately very hard to debug; typically
you have to bisect.

-Andi

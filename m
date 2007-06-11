Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXFKRlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXFKRlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbXFKRl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:41:29 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:44220 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbXFKRl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:41:28 -0400
Date: Mon, 11 Jun 2007 18:41:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de
Message-ID: <20070611174121.GA31647@srcf.ucam.org>
References: <20070611165112.GA30272@srcf.ucam.org> <p73d502uzsj.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73d502uzsj.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC] Runtime allocation of PCI resources
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 08:11:24PM +0200, Andi Kleen wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> 
> > BIOS authors don't always program all the features of hardware. This is 
> > often the case for Intel IDE controllers, which are usually able to run 
> > in AHCI mode but are rarely configured to do so. Reprogramming them is 
> > easy enough other than the requirement for some MMIO space. If the BIOS 
> > hasn't allocated this, it's necessary for us to do so manually.
> 
> Traditionally we've had bad experiences forcing hardware to do something
> the BIOS didn't consider. e.g. occasionally the BIOS has good reasons
> to not allow it; maybe it knows about some errata or other problem
> the kernel doesn't. 

AHCI is generally disabled because it makes Windows insanely difficult 
to install. I'm not aware of any hardware issues in this case.

> I tried something similar some time ago for the IOMMU aperture.
> It turned out that some systems put something into the e820 holes
> and didn't boot anymore if you put something else in there.
> Your resource allocation will just do that.
> 
> You might be lucky because your resources are typically
> small (IOMMU aperture was 64+MB) or you might not.

Hm. Yes, that would be a problem (sigh BIOS authors).
-- 
Matthew Garrett | mjg59@srcf.ucam.org

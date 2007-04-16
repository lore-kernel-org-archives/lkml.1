Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbXDPVks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbXDPVks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXDPVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:40:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45049 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbXDPVkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:40:47 -0400
Date: Mon, 16 Apr 2007 23:40:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, clemens@ladisch.de, bob.picco@hp.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Currid <ACurrid@nvidia.com>
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
Message-ID: <20070416214042.GB25508@one.firstfloor.org>
References: <1176708094.22969.7.camel@dual.local> <p734png6s1t.fsf@bingen.suse.de> <Pine.OSF.4.64.0704162337320.487506@kosh.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.OSF.4.64.0704162337320.487506@kosh.hut.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 12:28:31AM +0300, Mikko Tiihonen wrote:
> I actually was more worried that someone might complain that the pci 
> scanning is copy & paste code from end of the same file. I did try to use 
> the generic pci functions first but because they insist on enabling 
> interrupts they cannot be used this early. And this code needs to be run 
> before the timer initialization.

Yes that's the issue. You're adding another PCI scanner copy'n'pasted
from the caller of the function you're adding it to. See the problem?

> If you want I can submit a separate patch to move the ... not nice pci 
> scanning code to pci directory under some early_pci_scan(u32 *pci_ids, 
> hook) function. The same code was already cut&pasted in 

That is what early-quirks is anyways. But the way to scan for multple
things is not to add anther recursive scan, but to just extend or
change the main loop.

> >Also there should be done anything here without confirmation from
> >Nvidia that HPET is actually supposed to work. Sometimes hardware
> >is disabled by BIOS because it is seriously broken (there was at least
> >one other chipset that could corrupt your flash if you force enabled
> >HPET in some steppings)
> 
> I hope someone has some secret contacts at NVidia because they have not 
> been very open with their chipsets. I looked at LinuxBios and their NForce4 
> chipset code had just had commented out code that wrote to 0x44 register. 
> So obviously something more is needed.

Andy, can you help please?  There is interest in force enabling HPET on
boards where the BIOS didn't chose too. We would need a list of PCI-IDs
where this is safe to do and what bits to poke. Thanks.

-Andi

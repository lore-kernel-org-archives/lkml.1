Return-Path: <linux-kernel-owner+w=401wt.eu-S936298AbXFGAB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936298AbXFGAB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbXFGABU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:01:20 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:62061 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbXFGABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:01:19 -0400
Date: Wed, 06 Jun 2007 18:01:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.22-rc4-mm1
In-reply-to: <20070606095124.ae95529c.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Message-id: <46674AC7.6060605@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070606020737.4663d686.akpm@linux-foundation.org>
 <46669CE6.6060804@googlemail.com>
 <20070606095124.ae95529c.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yeah, this caused test.kernel.org to fail as well.
> 
> There are a couple of fixes in
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/hot-fixes/
> which should get things going again.
> 
> Robert, I spent some time picking at
> mmconfig-validate-against-acpi-motherboard-resources.patch then got bored
> with fiddling with it and reverted it outright.

The minimal fix would be to put #ifdef CONFIG_PCI_MMCONFIG around the 
call to pci_mmcfg_late_init in drivers/acpi/bus.c.

> 
> Please, we need to get those prototypes of pci_mmcfg_early_init() and
> pci_mmcfg_late_init() into some sane place which works on all
> architectures, not duplicate one of them in a C file and even see if we can
> avoid the #ifdef CONFIG_PCI_MMCONFIG in arch/i386/pci/init.c
> 
> This code area is really messy, due partly to the x86_64 and i386 sharing. 
> Any changes in there need careful testing and checking.

I'm not sure there's a point in making the prototypes for those 
functions global to all architectures, since it's unlikely anything 
non-X86 could make use of them with any similar semantics. We could 
provide a no-op definition of those functions to avoid the need to ifdef 
the calls, though.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbXGYKrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbXGYKrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXGYKrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:47:06 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45801 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbXGYKrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:47:05 -0400
Message-ID: <46A729FC.50407@s5r6.in-berlin.de>
Date: Wed, 25 Jul 2007 12:46:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.5) Gecko/20070716 SeaMonkey/1.1.3
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, David Miller <davem@davemloft.net>
Subject: Re: [patch 2.6.23-rc1] dma_free_coherent() needs irqs enabled (sigh)
References: <200707241429.05615.david-b@pacbell.net>
In-Reply-To: <200707241429.05615.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For linux1394-devel:

David Brownell wrote at LKML:
> On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
> call context requirement:  unlike its dma_alloc_coherent() sibling, it
> may not be called with IRQs disabled.  (This was new behavior on ARM as
> of late 2006, caused by ARM SMP updates.)  This little surprise can be
> annoyingly driver-visible.
> 
> Since it looks like that restriction won't be removed, this patch changes
> the definition of the API to include that requirement.  Also, to help
> catch nonportable drivers, it updates the x86 and swiotlb versions to
> include the relevant warnings.  (I already observed that it trips on the
> bus_reset_tasklet of the new firewire_ohci driver.)

Also in ohci_set_config_rom().
-- 
Stefan Richter
-=====-=-=== -=== ==--=
http://arcgraph.de/sr/

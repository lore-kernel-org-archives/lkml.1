Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZAaA2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZAaA2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbZAaA2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:28:37 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:1690 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZAaA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=G0ypGhpVOje7GvH+NN7fkaJIBM6K3f9nUxGGQpEFc5o8+exYrjTEWRDYK9eERzpzZK
         A8LgP3808jDZ0pTWvIaPcZoAUkg9fz67mxC9FIO3fui9m8+9TLk7WMzEFdrJS0TJuktK
         kHWqvo3EvKlo7ue1VPn5D2Y9WFvsWVjt/OJzw=
Date: Fri, 30 Jan 2009 19:28:25 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <200901310059.17746.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0901301924550.5056@parag-desktop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <alpine.LFD.2.00.0901301506120.3150@localhost.localdomain> <alpine.DEB.2.00.0901301826490.5027@parag-desktop> <200901310059.17746.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Jan 2009, Rafael J. Wysocki wrote:

> >  00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09)
> > -	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> > +	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> >  	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >  	Latency: 0, Cache Line Size: 64 bytes
> >  	Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=0
> 
> and the PCIe port driver may be at fault.
> 
> Can you try to remove the pci_save_state(dev) from pcie_port_suspend_late()
> and see if that helps?
> 

I assume you meant pcie_portdrv_suspend_late in 
drivers/pci/pcie/portdrv_pci.c - that one did not go well.

With that change machine refuses to suspend (comes back after attempting) 
and my keyboard goes dead.

Parag

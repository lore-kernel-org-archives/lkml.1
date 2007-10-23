Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbXJWFw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbXJWFw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXJWFws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:52:48 -0400
Received: from iabervon.org ([66.92.72.58]:40367 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbXJWFwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:52:47 -0400
Date: Tue, 23 Oct 2007 01:52:44 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: David Miller <davem@davemloft.net>
cc: jeff@garzik.org, linas@austin.ibm.com, chunhao.huang@hotmail.com,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
In-Reply-To: <20071022.171318.104036671.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710230049550.32497@iabervon.org>
References: <Pine.LNX.4.64.0710221555190.32497@iabervon.org>
 <471D0ADC.7000005@garzik.org> <Pine.LNX.4.64.0710221700120.32497@iabervon.org>
 <20071022.171318.104036671.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, David Miller wrote:

> My suggestion is:
> 
> 1) Leave the pci_intx() twiddling code in drivers/pci/msi.c
> 
> 2) Add quirks for "INTX_DISABLE turns off MSI too", this sets
>    a flag in the pci_dev.
> 
> 3) The pci_intx() calls in drivers/pci/msi.c are skipped if this
>    flag from #2 is set.
> 
> 4) Add quirk entries for drivers/net/tg3.c chips and these SATA
>    devices we are learning about here, as well as any others we
>    are aware of right now.
> 
> 5) Remove the pci_intx() workaround code from drivers/net/tg3.c
>    and elsewhere.

Seems right to me, and pretty straightforward, except that I don't really 
understand the pm-related logic in there to know how that should work and 
whether intx will need to be enabled somewhere in addition to not 
disabling it in the msi enable code.

	-Daniel
*This .sig left intentionally blank*

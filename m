Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbXJBDRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbXJBDRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 23:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXJBDRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 23:17:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:47778 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbXJBDRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 23:17:04 -0400
Subject: Re: [PATCH] powerpc: fix pci domain detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <200709261602.06214.arnd@arndb.de>
References: <200709261602.06214.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 13:16:49 +1000
Message-Id: <1191295009.6310.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-09-26 at 16:02 +0200, Arnd Bergmann wrote:
> The /proc/bus/pci/* files list PCI domain numbers only for
> devices that claim to be on a multi-domain system. The check
> for this is broken on powerpc, because the buid value is
> truncated to 32 bits.
> 
> There is at least one machine (IBM QS21) that only uses
> the high-order bits of the buid, so the return value
> of pci_proc_domain() ends up being always zero, which
> makes /proc/bus/pci useless.
> 
> Change the logic to always return '1' for a nonzero
> buid value.
> 
> Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

Good catch !

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> 
> diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> index 291ffbc..9f63bdc 100644
> --- a/arch/powerpc/kernel/pci_64.c
> +++ b/arch/powerpc/kernel/pci_64.c
> @@ -588,7 +588,7 @@ int pci_proc_domain(struct pci_bus *bus)
>  		return 0;
>  	else {
>  		struct pci_controller *hose = pci_bus_to_host(bus);
> -		return hose->buid;
> +		return hose->buid != 0;
>  	}
>  }
>  
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev


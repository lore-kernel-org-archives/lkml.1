Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390Ab0AUVc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0AUVc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911Ab0AUVc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:32:28 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30961 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab0AUVc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:32:28 -0500
Date: Thu, 21 Jan 2010 14:32:26 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 9/9] pci: set PCI_PREF_RANGE_TYPE_64 in
	pci_bridge_check_ranges
Message-ID: <20100121213226.GI17684@ldl.fc.hp.com>
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-10-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264054456-12694-10-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> make pci_bridge_check_ranges() to store the
> PCI_PREF_RANGE_TYPE_64 in addition to IORESOURCE_MEM_64. just
> like pci_read_bridge_bases()
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index a9c4f9e..8fafe73 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -359,8 +359,11 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
>  	}
>  	if (pmem) {
>  		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
> -		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
> +		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) ==
> +		    PCI_PREF_RANGE_TYPE_64) {
>  			b_res[2].flags |= IORESOURCE_MEM_64;
> +			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
> +		}
>  	}

My copy of pci_read_bridge_bases() in jbarnes's linux-next tree
doesn't do anything like that.

 284 void __devinit pci_read_bridge_bases(struct pci_bus *child)
 285 {
 ...
 369         if (base <= limit) {
 370                 res->flags = (mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) |
 371                                          IORESOURCE_MEM | IORESOURCE_PREFETCH;
 372                 if (res->flags & PCI_PREF_RANGE_TYPE_64)
 373                         res->flags |= IORESOURCE_MEM_64;
 374                 res->start = base;
 375                 res->end = limit + 0xfffff;
 376                 dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 377         }

What's going on?

/ac

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbXJVBxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbXJVBxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 21:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXJVBxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 21:53:38 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:43086 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXJVBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 21:53:37 -0400
Message-ID: <471C029A.9050500@tiscali.nl>
Date: Mon, 22 Oct 2007 03:53:30 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
References: <471BF741.2020501@tiscali.nl> <20071021214209.1a7567d7@bree.surriel.com>
In-Reply-To: <20071021214209.1a7567d7@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Mon, 22 Oct 2007 03:05:05 +0200
> Roel Kluin <12o3l@tiscali.nl> wrote:
> 
>>     return hidden bug
>>     
>>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>>
>> diff --git a/arch/alpha/kernel/pci_iommu.c
>> b/arch/alpha/kernel/pci_iommu.c index e1c4707..6a69425 100644
>> --- a/arch/alpha/kernel/pci_iommu.c
>> +++ b/arch/alpha/kernel/pci_iommu.c
>> @@ -365,8 +365,8 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t
>> dma_addr, size_t size, printk(KERN_ERR "Bogus pci_unmap_single:
>> dma_addr %lx " " base %lx size %x\n", dma_addr, arena->dma_base,
>>  		       arena->size);
>> -		return;
>>  		BUG();
>> +		return;
>>  	}
>>  
>>  	npages = calc_npages((dma_addr & ~PAGE_MASK) + size);
> 
> BUG() will terminate the process that runs into it, so you can
> just remove the return alltogether.  If BUG() is hit, the return
> will never be reached.
> 
---
    hidden bug returns
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index e1c4707..ca55c33 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -365,7 +365,6 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
 		printk(KERN_ERR "Bogus pci_unmap_single: dma_addr %lx "
 		       " base %lx size %x\n", dma_addr, arena->dma_base,
 		       arena->size);
-		return;
 		BUG();
 	}
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZGWPov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZGWPov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZGWPou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:44:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:43831 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbZGWPot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:44:49 -0400
Cc: beckyb@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-Id: <26996510-F41B-4B4C-8AA1-80CD23E4F435@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090723160855S.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: removing addr_needs_map in struct dma_mapping_ops
Date: Thu, 23 Jul 2009 10:44:25 -0500
References: <B6C36B32-6861-4FD9-B8A3-E8C328687E0F@kernel.crashing.org> <20090714094919V.fujita.tomonori@lab.ntt.co.jp> <79B7CF70-0A66-43DA-91ED-3C8638FED141@kernel.crashing.org> <20090723160855S.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23, 2009, at 2:09 AM, FUJITA Tomonori wrote:

>>> diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/
>>> powerpc/platforms/86xx/mpc86xx_hpcn.c
>>> index 6632702..d1878f3 100644
>>> --- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
>>> +++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
>>> @@ -187,5 +187,6 @@ define_machine(mpc86xx_hpcn) {
>>> 	.progress		= udbg_progress,
>>> #ifdef CONFIG_PCI
>>> 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
>>> +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
>>> #endif
>>> };
>>
>> Instead of initializing this here (which has problems if !
>> CONFIG_SWIOTLB),
>
> Oops, I overlooked it.
>
>
>> place this in the xxxxx_xxxx_setup_arch function in
>> the same files, which already have an #ifdef CONFIG_SWIOTLB in which
>> this can be embedded.
>
> But the xxxxx_xxxx_setup_arch function doesn't access to each device
> so we need to add something like for_each_pci_dev()? You prefer that?

No.. I think what we want is:

#ifdef CONFIG_SWIOTLB
         if (lmb_end_of_DRAM() > max) {
                 ppc_swiotlb_enable = 1;
                 set_pci_dma_ops(&swiotlb_pci_dma_ops);
		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
         }
#endif

Buts its been a few days since Becky & I chatted about this and I feel  
like I'm forgetting something.

- k

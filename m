Return-Path: <linux-kernel-owner+w=401wt.eu-S1764572AbZDHU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764572AbZDHU6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZDHU6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:58:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:41239 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbZDHU6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:58:06 -0400
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Message-Id: <7366A4DE-6848-4AF6-AA33-6BD89B0A5153@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090408203823.GA14985@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
Date: Wed, 8 Apr 2009 15:56:32 -0500
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org> <1239199761-22886-2-git-send-email-galak@kernel.crashing.org> <1239199761-22886-3-git-send-email-galak@kernel.crashing.org> <1239199761-22886-4-git-send-email-galak@kernel.crashing.org> <1239199761-22886-5-git-send-email-galak@kernel.crashing.org> <20090408203823.GA14985@infradead.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8, 2009, at 3:38 PM, Christoph Hellwig wrote:

> On Wed, Apr 08, 2009 at 09:09:18AM -0500, Kumar Gala wrote:
>> From: Becky Bruce <beckyb@kernel.crashing.org>
>>
>> Some architectures require additional checking to determine
>> if a device can dma to an address and need to provide their
>> own address_needs_mapping..
>
> Shouldn't we just move it completely to the arch?  I think that ia64  
> and
> x86 currently use the same one is more of an accident.

It seems like the swiotlb code uses __weak for a number of things:

lib/swiotlb.c:void * __weak __init swiotlb_alloc_boot(size_t size,  
unsigned long nslabs)
lib/swiotlb.c:void * __weak swiotlb_alloc(unsigned order, unsigned  
long nslabs)
lib/swiotlb.c:dma_addr_t __weak swiotlb_phys_to_bus(struct device  
*hwdev, phys_addr_t paddr)
lib/swiotlb.c:phys_addr_t __weak swiotlb_bus_to_phys(struct device  
*hwdev, dma_addr_t baddr)
lib/swiotlb.c:void * __weak swiotlb_bus_to_virt(struct device *hwdev,  
dma_addr_t address)
lib/swiotlb.c:int __weak swiotlb_arch_address_needs_mapping(struct  
device *hwdev,
lib/swiotlb.c:int __weak swiotlb_arch_range_needs_mapping(phys_addr_t  
paddr, size_t size)

instead of #ifndef HAVE_ARCH_<FOO>.  Not sure if there is a historical  
reason for that.

- k

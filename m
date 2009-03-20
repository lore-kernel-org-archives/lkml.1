Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZCTCre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZCTCre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZCTCrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:47:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:19784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbZCTCrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:47:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396036154"
Message-ID: <49C303B5.5040707@intel.com>
Date: Fri, 20 Mar 2009 10:47:17 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com> <20090319193043.583ad601@hobbes.lan>
In-Reply-To: <20090319193043.583ad601@hobbes.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Thu, 12 Feb 2009 20:50:32 +0800
> Yu Zhao <yu.zhao@intel.com> wrote:
> 
>> This patch series implements Address Translation Service support for
>> the Intel IOMMU. ATS makes the PCI Endpoint be able to request the
>> DMA address translation from the IOMMU and cache the translation in
>> the Endpoint, thus alleviate IOMMU pressure and improve the hardware
>> performance in the I/O virtualization environment.
>>
>>
>> Changelog: v2 -> v3
>>   1, throw error message if VT-d hardware detects invalid descriptor
>>      on Queued Invalidation interface (David Woodhouse)
>>   2, avoid using pci_find_ext_capability every time when reading ATS
>>      Invalidate Queue Depth (Matthew Wilcox)
>> Changelog: v1 -> v2
>>   added 'static' prefix to a local LIST_HEAD (Andrew Morton)
>>
>>
>> Yu Zhao (6):
>>   PCI: support the ATS capability
>>   VT-d: parse ATSR in DMA Remapping Reporting Structure
>>   VT-d: add queue invalidation fault status support
>>   VT-d: add device IOTLB invalidation support
>>   VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
>>   VT-d: support the device IOTLB
> 
> Um nevermind, this should go through the IOMMU tree (David?).

If it's possible, I'd like it go through the PCI tree because the ATS 
depends on the SR-IOV. This dependency is not reflected in this v3 
series since the SR-IOV is not in-tree and I don't want to break the 
build after people apply the ATS on their tree.

So Dave, can I get an ack from you and let Jesse pull the IOMMU change 
to his tree? Or let this ATS go to 2.6.31?

Thanks,
Yu

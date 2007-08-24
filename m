Return-Path: <linux-kernel-owner+w=401wt.eu-S1765514AbXHXVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765514AbXHXVu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXHXVuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:50:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:35878 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXHXVuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:50:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="267717081"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 -mm 7/7] I/OAT: Add DCA services
Date: Fri, 24 Aug 2007 14:50:11 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02EB5621@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070824121217.3048147c.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 -mm 7/7] I/OAT: Add DCA services
thread-index: Acfmg2s2tBxn8FCBR7aXk7Z5t22ItgAFPVmw
References: <20070824001335.16997.79665.stgit@localhost.localdomain><20070824001527.16997.2238.stgit@localhost.localdomain> <20070824121217.3048147c.randy.dunlap@oracle.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>
X-OriginalArrivalTime: 24 Aug 2007 21:50:12.0447 (UTC) FILETIME=[BF6EB6F0:01C7E698]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap [mailto:randy.dunlap@oracle.com] 
>
>On Thu, 23 Aug 2007 17:15:27 -0700 Shannon Nelson wrote:
>
[...]
>> +
>> +/* THIS STUFF NEEDS TO LIVE SOMEWHERE ELSE */
>> +#define X86_FEATURE_DCA	(4*32+18) /* Direct Cache Access */
>> +/* / THIS STUFF NEEDS TO LIVE SOMEWHERE ELSE */
>
>Yes, feature bits need to be integrated with the other CPU-specific
>feature bits.

Added to include/asm-i386/cpufeature.h, which is also used by the x86_64
version.

>
>> +/* pack PCI B/D/F into a u16 */
>> +static inline u16 dcaid_from_pcidev(struct pci_dev *pci)
>> +{
>> +	return (pci->bus->number << 8) | pci->devfn;
>> +}
>
>Could any other PCI users use this in include/linux/pci.h ?

Possibly, but I don't know pci well enough to know for sure, so I'll let
someone else jmp in here.

>
>
>> diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
>> index 5931e56..d59c90b 100644
>> --- a/drivers/dma/ioatdma.h
>> +++ b/drivers/dma/ioatdma.h
>> @@ -132,9 +132,11 @@ struct ioat_desc_sw {
>>  #if defined(CONFIG_INTEL_IOATDMA) || 
>defined(CONFIG_INTEL_IOATDMA_MODULE)
>>  struct ioatdma_device *ioat_dma_probe(struct pci_dev *, 
>void __iomem *);
>>  void ioat_dma_remove(struct ioatdma_device *device);
>> +struct dca_provider *ioat_dca_init(struct pci_dev *, void 
>__iomem *);
>
>Parameter (variable) names in prototypes, please.

Done.

Thanks again,
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYJOCE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYJOCE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYJOCEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:04:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:49287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbYJOCEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:04:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,413,1220252400"; 
   d="scan'208";a="451345692"
Message-ID: <48F54FAF.7060204@intel.com>
Date: Wed, 15 Oct 2008 10:04:31 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 6/8 v4] PCI: support the SR-IOV capability
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com> <20081014105928.GF1734@yzhao12-linux.sh.intel.com> <20081014123002.GA15064@parisc-linux.org>
In-Reply-To: <20081014123002.GA15064@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Oct 14, 2008 at 06:59:28PM +0800, Yu Zhao wrote:
>> +++ b/include/linux/pci.h
>> @@ -87,6 +87,12 @@ enum {
>>       /* #6: expansion ROM */
>>       PCI_ROM_RESOURCE,
>>
>> +     /* device specific resources */
>> +#ifdef CONFIG_PCI_IOV
>> +     PCI_IOV_RESOURCES,
>> +     PCI_IOV_RESOURCES_END = PCI_IOV_RESOURCES + PCI_IOV_NUM_BAR - 1,
>> +#endif
>> +
>>       /* address space assigned to buses behind the bridge */
>>  #ifndef PCI_BRIDGE_RES_NUM
>>  #define PCI_BRIDGE_RES_NUM 4
> 
> Why expand the number of resources in struct pci_dev instead of putting
> the new resources in struct pci_iov?

Yes, it's supposed to be in the 'struct pci_iov', and the resources used 
to be there in early version. But later I found all resource related 
functions such as pci_assign_resource, pdev_sort_resources, 
pbus_size_mem, etc. assume the resources are bundled with 'struct 
pci_dev' and address them using their indexes. Encapsulating resources 
into 'pci_iov' will impact all these functions. And I think we can 
postpone the change of these functions until the PCIM comes out, if the 
IOV is the only one who uses non-standard resources.

> 
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."


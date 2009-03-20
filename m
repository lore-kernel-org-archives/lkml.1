Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbZCTD2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbZCTD2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbZCTD2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:28:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:21979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZCTD2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="440471755"
Message-ID: <49C30D4F.2050903@intel.com>
Date: Fri, 20 Mar 2009 11:28:15 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/8] PCI: initialize and release SR-IOV capability
References: <1236756349-18892-1-git-send-email-yu.zhao@intel.com>	<1236756349-18892-2-git-send-email-yu.zhao@intel.com>	<20090319195312.GC14127@parisc-linux.org> <20090319182016.33a9a1f2@hobbes.lan>
In-Reply-To: <20090319182016.33a9a1f2@hobbes.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Thu, 19 Mar 2009 13:53:12 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
>> On Wed, Mar 11, 2009 at 03:25:42PM +0800, Yu Zhao wrote:
>>> +config PCI_IOV
>>> +	bool "PCI IOV support"
>>> +	depends on PCI
>>> +	help
>>> +	  PCI-SIG I/O Virtualization (IOV) Specifications support.
>>> +	  Single Root IOV: allows the creation of virtual PCI
>>> devices
>>> +	  that share the physical resources from a real device.
>>> +
>>> +	  When in doubt, say N.
>> It's certainly shorter than my text, which is nice.  But I think it
>> still has too much spec-ese and not enough explanation.  How about:
>>
>> 	help
>> 	  I/O Virtualization is a PCI feature supported by some
>> devices which allows them to create virtual devices which share their
>> 	  physical resources.
>>
>> 	  If unsure, say N.
>>
>>> +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
>>> +		if (pdev->is_physfn)
>>> +			break;
>>> +	if (list_empty(&dev->bus->devices) || !pdev->is_physfn)
>>> +		pdev = NULL;
>> This is still wrong.  If the 'break' condition is not hit, pdev is
>> pointing to garbage, not to the last pci_dev in the list.
>>
>>> @@ -270,6 +278,7 @@ struct pci_dev {
>>>  	struct list_head msi_list;
>>>  #endif
>>>  	struct pci_vpd *vpd;
>>> +	struct pci_sriov *sriov;	/* SR-IOV capability
>>> related */
>> Should be ifdeffed?
> 
> Ok Yu, I'm ready to apply this set, can you send an updated one with
> the fixes Matthew mentioned?

Thanks, Jesse. I updated this one according to Matthew's comments and 
respan others in patchset v12 so they can be cleanly applied.

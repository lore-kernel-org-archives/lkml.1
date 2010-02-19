Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0BSCOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 21:14:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36347 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0BSCOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 21:14:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B7DF266.6050201@jp.fujitsu.com>
Date: Fri, 19 Feb 2010 11:07:34 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 2/8] PCI PM: PCIe PME root port service driver (rev. 5)
References: <201002172335.47703.rjw@sisk.pl> <201002172339.08865.rjw@sisk.pl> <4B7CBD37.9000706@jp.fujitsu.com> <201002182057.53002.rjw@sisk.pl>
In-Reply-To: <201002182057.53002.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 18 February 2010, Kenji Kaneshige wrote:
>> Hi,
>>
>> I'm sorry for the delayed comments.
>>
>>> +
>>> +/**
>>> + * pcie_pme_interrupt_enable - Enable/disable PCIe PME interrupt generation.
>>> + * @dev: PCIe root port or event collector.
>>> + * @enable: Enable or disable the interrupt.
>>> + */
>>> +static void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
>>> +{
>>> +	int rtctl_pos;
>>> +	u16 rtctl;
>>> +
>>> +	rtctl_pos = pci_find_capability(dev, PCI_CAP_ID_EXP) + PCI_EXP_RTCTL;
>> How about
>>
>> 	rtctl_pos = pci_pcie_cap(dev) + PCI_EXP_RTCTL;
>>
>> ?
>>
>> The pci_pcie_cap() returns PCIe capability offset saved in struct pci_dev.
>> By using this, we can avoid redundant search in PCI configuration space.
> 
> While I agree with the comment, I'd prefer to change this with a separate
> patch, unless the entire patchset misses the merge window.
> 

Ok. Actually, I didn't realize your set of patches was already in
linux-next, sorry. I'll send a patch as a separate one.

Thanks,
Kenji Kaneshige


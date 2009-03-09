Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZCINqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZCINqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZCINp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:45:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35661 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZCINp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:45:57 -0400
Message-ID: <49B51D90.5090603@redhat.com>
Date: Mon, 09 Mar 2009 15:45:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Yang, Sheng" <sheng.yang@intel.com>
CC: Matthew Wilcox <matthew@wil.cx>, "Zhao, Yu" <yu.zhao@intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <49B3D678.4050004@redhat.com> <200903091142.06628.sheng.yang@intel.com> <200903091235.43083.sheng.yang@intel.com>
In-Reply-To: <200903091235.43083.sheng.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yang, Sheng wrote:
>>> Patches 2 and 3 of the patchset that enables SR/IOV in kvm [1] suggest
>>> that at the config space is only partially implemented.
>>>
>>> [1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/29034
>>>       
>> Hi Avi
>>
>> For kernel side, patch 2 is not necessary. Because kernel would read
>> VID/DID directly from pci_dev rather than configuration space, which have
>> been set properly already.
>>
>> And very sorry, for the patch 3. We haven't known exactly what's happened.
>> I think the problem is caused by guest driver, but didn't confirm(and I
>> have some misunderstandings with ZhaoYu for I thought we are agree on the
>> reason, but after confirm with him, he didn't agree). I am doing more
>> investigations to find the real cause.
>>     
>
> Found the reason of patch 3.
>
> After insert guest driver module(vf driver), the driver would do a RMW to the 
> command register to enable Bus Master bit(bit 2). And before that, MMIO bit 
> have been set in the register. But without the patch 3, guest driver won't see 
> the MMIO bit(bit 1), then just set 0x4 to the command register, with the side 
> effect to unmap MMIO in QEmu. So patch 3 is needed(and what I thought before 
> is right).
>
> Unset the bit only affect the QEmu, which would unmap the mapping for MMIO. 
> Kernel side don't need this, so it's OK.
>   

Thanks for the explanations!

-- 
error compiling committee.c: too many arguments to function


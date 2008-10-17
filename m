Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYJQGDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYJQGDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYJQGDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:03:07 -0400
Received: from avexch2.qlogic.com ([198.70.193.116]:14825 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYJQGDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:03:06 -0400
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 02:03:06 EDT
Cc: "Dong, Eddie" <eddie.dong@intel.com>, "Zhao, Yu" <yu.zhao@intel.com>,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Message-Id: <5F847B2D-D033-4A40-B132-A900E28EB36A@qlogic.com>
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
To: Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <20081014044626.GB25780@parisc-linux.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 6/6 v3] PCI: document the change
Date: Thu, 16 Oct 2008 22:48:56 -0700
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F6@pdsmsx502.ccr.corp.intel.com> <20081001160706.GI13822@parisc-linux.org> <08DF4D958216244799FC84F3514D70F00235CC69@pdsmsx415.ccr.corp.intel.com> <20081014010827.GX25780@parisc-linux.org> <08DF4D958216244799FC84F3514D70F00235CE27@pdsmsx415.ccr.corp.intel.com> <20081014021435.GA1482@yzhao12-linux.sh.intel.com> <20081014040105.GA25780@parisc-linux.org> <08DF4D958216244799FC84F3514D70F00235CF5E@pdsmsx415.ccr.corp.intel.com> <20081014044626.GB25780@parisc-linux.org>
X-Mailer: Apple Mail (2.929.2)
X-OriginalArrivalTime: 17 Oct 2008 05:48:53.0322 (UTC) FILETIME=[097DB2A0:01C9301C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13, 2008, at 9:46 PM, Matthew Wilcox wrote:

> On Tue, Oct 14, 2008 at 12:18:40PM +0800, Dong, Eddie wrote:
>> Matthew Wilcox wrote:
>>> On Tue, Oct 14, 2008 at 10:14:35AM +0800, Yu Zhao wrote:
>>>> As Eddie said, we have two problems here:
>>>> 1) User has to set device specific parameters of a VF
>>>> when he wants to use this VF with KVM (assign this
>>>> device to KVM guest). In this case,
>>>> VF driver is not loaded in the host environment. So
>>>> operations which
>>>> are implemented as driver callback (e.g.
>>>> set_mac_address()) are not supported.
>>>
>>> I suspect what you want to do is create, then configure
>>> the device in the host, then assign it to the guest.
>>
>> That is not true. Rememver the created VFs will be destroyed no  
>> matter
>> for PF power event or error recovery conducted reset.
>> So what we want is:
>>
>> Config, create, assign, and then deassign and destroy and then
>> recreate...
>
> Yes, but my point is this all happens in the _host_, not in the  
> _guest_.
>
>> Sorry can u explain a little bit more? The SR-IOV patch won't define
>> what kind of entries should be created or not, we leave network
>> subsystem to decide what to do. Same for disk subsstem etc.
>
> No entries should be created.  This needs to be not SR-IOV specific.

I think we need to cover both the scenarios here, virtualization and  
non virtualization. In the absence of virtualization, the VF and PF  
driver should be identical. In this context, how does the PF driver  
allocates a VF? Is dynamic allocation of VFs possible, or does it have  
to allocate all the VFs that the device supports when the PF driver  
loads? Also, will the probe function be called for the VFs, or does  
the PF driver handle only the probe for the physical function? In  
virtualization context things get bit more complex as the the VF  
driver in guest would like to treat the VF as a physical function but  
that may not be possible from the device perspective as the control  
registers may well be shared between VF and PF.
I would think that the VF allocation is the job of SR PCIM. PCIM may  
well ask the PF driver to configure a VF upon user request.

Thanks much,
Anirban Chakraborty

> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


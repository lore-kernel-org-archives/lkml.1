Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbZDSIe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbZDSIe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZDSIeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:34:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZDSIeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:34:14 -0400
Message-ID: <49EAE1F6.9050205@redhat.com>
Date: Sun, 19 Apr 2009 11:33:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws>
In-Reply-To: <49EA515C.9000507@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>>
>> Then we would need to tell which read-only MSRs are setup writeable 
>> and which aren't...
>>
>> I'm okay with an ioctl to setup MCE, but just make sure userspace has 
>> all the information to know what the kernel can do rather than the 
>> try-and-see-if-it-works approach.  We can publish this information 
>> via KVM_CAP things, or via another ioctl (see 
>> KVM_GET_SUPPORTED_CPUID2 for an example).
>
> Why not introduce a new exit type for MSR reads/writes that aren't 
> handled by the kernel?  You just need a bit on the return that 
> indicates whether to GPF because of an invalid MSR access.
>
> KVM_SET_MSRs should be reserved for MSRs that are performance 
> sensitive.  Not all of them will be.
>

Right now everything in the vcpu is emulated in the kernel.  Everything 
else is emulated either in the kernel (irqchip) or in userspace.  This 
makes things easier to understand, and is more future friendly if more 
cpu features become virtualized by hardware.

While these are not compelling reasons, they at least lean the balance 
in favour of a kernel implementation.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZDUQLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZDUQLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZDUQKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:10:55 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:48900 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZDUQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:10:54 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 12:10:53 EDT
Message-ID: <49EDEE93.30103@codemonkey.ws>
Date: Tue, 21 Apr 2009 11:04:35 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com>
In-Reply-To: <49EAE1F6.9050205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>> Avi Kivity wrote:
>>>
>>> Then we would need to tell which read-only MSRs are setup writeable 
>>> and which aren't...
>>>
>>> I'm okay with an ioctl to setup MCE, but just make sure userspace 
>>> has all the information to know what the kernel can do rather than 
>>> the try-and-see-if-it-works approach.  We can publish this 
>>> information via KVM_CAP things, or via another ioctl (see 
>>> KVM_GET_SUPPORTED_CPUID2 for an example).
>>
>> Why not introduce a new exit type for MSR reads/writes that aren't 
>> handled by the kernel?  You just need a bit on the return that 
>> indicates whether to GPF because of an invalid MSR access.
>>
>> KVM_SET_MSRs should be reserved for MSRs that are performance 
>> sensitive.  Not all of them will be.
>>
>
> Right now everything in the vcpu is emulated in the kernel.  
> Everything else is emulated either in the kernel (irqchip) or in 
> userspace.  This makes things easier to understand, and is more future 
> friendly if more cpu features become virtualized by hardware.

Except cpuid, which is handled in userspace, sort of :-)  I think the 
same arguments apply here too.

Regards,

Anthony Liguori

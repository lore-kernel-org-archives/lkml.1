Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZDTMVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZDTMVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZDTMVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:21:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39521 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbZDTMVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:21:09 -0400
Message-ID: <49EC68A7.8080403@redhat.com>
Date: Mon, 20 Apr 2009 14:20:55 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com>
In-Reply-To: <49EC5C3A.6020108@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/09 13:27, Avi Kivity wrote:
> Gerd Hoffmann wrote:
>>>> Well, xenner doesn't do vmcalls, so the page isn't vendor specific.
>>>
>>> Well, for true pv (not pv-on-hvm) it wouldn't use the MSR, would it?
>>
>> Yes, the MSR is used for pv-on-hvm only.
>
> So it isn't relevant for Xenner?

It is.  I still plan to merge xenner into qemu, and also support 
xenstyle pv-on-hvm drivers.

> That said, I'd like to be able to emulate the Xen HVM hypercalls. But in
> any case, they hypercall implementation has to be in the kernel,

No.  With Xenner the xen hypercall emulation code lives in guest address 
space.

> so I
> don't see why the MSR shouldn't be.

I don't care that much, but /me thinks it would be easier to handle in 
userspace ...

> Especially if we need to support
> tricky bits like continuations.

Is there any reason to?  I *think* xen does it for better scheduling 
latency.  But with xen emulation sitting in guest address space we can 
schedule the guest at will anyway.

>> Same MSR, multiple writes (page number in the low bits).
>
> Nasty. The hypervisor has to remember all of the pages, so it can update
> them for live migration.

Xenner doesn't need update-on-migration, so there is no need at all to 
remember this.  At the end of the day it is just memcpy(guest, data, 
PAGESIZE) triggered by wrmsr.

cheers,
   Gerd

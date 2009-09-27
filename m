Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZI0Ion@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZI0Ion (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZI0Ion
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbZI0Iom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:44:42 -0400
Message-ID: <4ABF25F8.3050209@redhat.com>
Date: Sun, 27 Sep 2009 10:44:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH: kvm 3/6] Fix hotadd of CPUs for KVM.
References: <1253762945-5750-1-git-send-email-zamsden@redhat.com> <1253762945-5750-2-git-send-email-zamsden@redhat.com> <1253762945-5750-3-git-send-email-zamsden@redhat.com> <20090924155224.GC14102@amt.cnet> <4ABBD76D.6050308@redhat.com>
In-Reply-To: <4ABBD76D.6050308@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2009 11:32 PM, Zachary Amsden wrote:
> On 09/24/2009 05:52 AM, Marcelo Tosatti wrote:
>>
>>> +static __cpuinit int vmx_cpu_hotadd(int cpu)
>>> +{
>>> +    struct vmcs *vmcs;
>>> +
>>> +    if (per_cpu(vmxarea, cpu))
>>> +        return 0;
>>> +
>>> +    vmcs = alloc_vmcs_cpu(cpu);
>>> +    if (!vmcs)
>>> +        return -ENOMEM;
>>> +
>>> +    per_cpu(vmxarea, cpu) = vmcs;
>>> +
>>> +    return 0;
>>> +}
>> Have to free in __cpuexit?
>>
>> Is it too wasteful to allocate statically with 
>> DEFINE_PER_CPU_PAGE_ALIGNED?
>
> Unfortunately, I think it is.  The VMX / SVM structures are quite 
> large, and we can have a lot of potential CPUs.

I think percpu is only allocated when the cpu is online (it would still 
be wasteful if the modules were loaded but unused).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZIXUeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZIXUeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIXUet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZIXUes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:34:48 -0400
Message-ID: <4ABBD76D.6050308@redhat.com>
Date: Thu, 24 Sep 2009 10:32:45 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH: kvm 3/6] Fix hotadd of CPUs for KVM.
References: <1253762945-5750-1-git-send-email-zamsden@redhat.com> <1253762945-5750-2-git-send-email-zamsden@redhat.com> <1253762945-5750-3-git-send-email-zamsden@redhat.com> <20090924155224.GC14102@amt.cnet>
In-Reply-To: <20090924155224.GC14102@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2009 05:52 AM, Marcelo Tosatti wrote:
>
>> +static __cpuinit int vmx_cpu_hotadd(int cpu)
>> +{
>> +	struct vmcs *vmcs;
>> +
>> +	if (per_cpu(vmxarea, cpu))
>> +		return 0;
>> +
>> +	vmcs = alloc_vmcs_cpu(cpu);
>> +	if (!vmcs)
>> +		return -ENOMEM;
>> +
>> +	per_cpu(vmxarea, cpu) = vmcs;
>> +
>> +	return 0;
>> +}
>>      
> Have to free in __cpuexit?
>
> Is it too wasteful to allocate statically with DEFINE_PER_CPU_PAGE_ALIGNED?
>    

Unfortunately, I think it is.  The VMX / SVM structures are quite large, 
and we can have a lot of potential CPUs.

Zach

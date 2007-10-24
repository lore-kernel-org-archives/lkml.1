Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbXJXIhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbXJXIhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXJXIgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:36:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:52416 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXJXIgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:36:54 -0400
Message-ID: <471F03F5.7090608@qumranet.com>
Date: Wed, 24 Oct 2007 10:36:05 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 6/12] KVM: work around SMP requirement
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org>
In-Reply-To: <471E79E2.2090204@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Adrian Bunk wrote:
>> On Tue, Oct 23, 2007 at 06:36:40PM -0400, Jeff Garzik wrote:
>>> KVM is currently completely broken for the !CONFIG_SMP case.
>>>
>>> drivers/kvm/kvm_main.c: In function ‘kvm_flush_remote_tlbs’:
>>> drivers/kvm/kvm_main.c:220: error: implicit declaration of function 
>>> ‘smp_call_function_mask’
>>>
>>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>>> ---
>>> I hope the KVM maintainer can come up with a better solution...
>>>
>>> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
>>> index 8749fa4..e35fbc6 100644
>>> --- a/drivers/kvm/Kconfig
>>> +++ b/drivers/kvm/Kconfig
>>> @@ -16,7 +16,7 @@ if VIRTUALIZATION
>>>  
>>>  config KVM
>>>      tristate "Kernel-based Virtual Machine (KVM) support"
>>> -    depends on X86 && EXPERIMENTAL
>>> +    depends on X86 && EXPERIMENTAL && SMP
>>> ...
>>
>> Assuming it won't get fixed soon, the pattern would be "(SMP || 
>> BROKEN)".
>>
>> The effect is the same, but this makes it more obvious that KVM does 
>> not depend architecturally on SMP but just broken.
>>
>> Of course, the preferred solution is to simply get KVM fixed...
>
> In general I agree, but I specifically avoided CONFIG_BROKEN in case 
> it was an intentional choice to require an SMP kernel.
>

Of course SMP is not required.  I'll submit a patch to make 
smp_call_function_mask() available on UP kernels.  Andrew, please don't 
apply the KVM Kconfig patch.

-- 
error compiling committee.c: too many arguments to function


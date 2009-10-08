Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbZJHQU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbZJHQU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbZJHQUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484AbZJHQUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:20:55 -0400
Message-ID: <4ACE113A.7020708@redhat.com>
Date: Thu, 08 Oct 2009 18:20:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] KVM: SVM: Add tracepoint for nested vmrun
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com> <1254996199-17667-4-git-send-email-joerg.roedel@amd.com> <4ACE0C1E.40506@redhat.com> <20091008161545.GE14073@amd.com>
In-Reply-To: <20091008161545.GE14073@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 06:15 PM, Joerg Roedel wrote:
> On Thu, Oct 08, 2009 at 05:58:22PM +0200, Avi Kivity wrote:
>    
>> On 10/08/2009 12:03 PM, Joerg Roedel wrote:
>>      
>>> This patch adds a dedicated kvm tracepoint for a nested
>>> vmrun.
>>>
>>> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
>>> ---
>>>   arch/x86/kvm/svm.c   |    6 ++++++
>>>   arch/x86/kvm/trace.h |   33 +++++++++++++++++++++++++++++++++
>>>   arch/x86/kvm/x86.c   |    1 +
>>>   3 files changed, 40 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index 884bffc..907af3f 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -1726,6 +1726,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>>>   	/* nested_vmcb is our indicator if nested SVM is activated */
>>>   	svm->nested.vmcb = svm->vmcb->save.rax;
>>>
>>> +	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, svm->nested.vmcb,
>>> +			       nested_vmcb->save.rip,
>>> +			       nested_vmcb->control.int_ctl,
>>> +			       nested_vmcb->control.event_inj,
>>> +			       nested_vmcb->control.nested_ctl);
>>> +
>>>        
>> It's better to pass only 'svm' as argument and have the tracepoint
>> code derive everything else, since (I think) argument setup is done
>> unconditionally, and only the actual trace_kvm call is patched out.
>> It may not work out due to where the trace code is compiled, but
>> it's worth trying.
>>      
> Hmm, struct vcpu_svm is defined in svm.c and local to that file. It is
> not known in x86.c, where the tracepoints are compiled, or in svm.c
> where trace.h is included. Is this tracepoint it worth it to move the
> definition of vcpu_svm into a (x86-)global header?
>    

I was talking about all svm tracepoints, but no, it isn't worth it.  
Let's leave it till later.

-- 
error compiling committee.c: too many arguments to function


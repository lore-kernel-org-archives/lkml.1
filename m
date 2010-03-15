Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936155Ab0COMwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:52:44 -0400
Received: from 8bytes.org ([88.198.83.132]:43609 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936210Ab0COMwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:52:41 -0400
Date: Mon, 15 Mar 2010 13:52:40 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Daniel K." <dk@uw.no>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] KVM: MMU: Propagate the right fault back to the
	guest after gva_to_gpa
Message-ID: <20100315125240.GD13108@8bytes.org>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-16-git-send-email-joerg.roedel@amd.com> <4B9DB7F7.6010902@uw.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9DB7F7.6010902@uw.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 04:30:47AM +0000, Daniel K. wrote:
> Joerg Roedel wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 2883ce8..9f8b02d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -314,6 +314,19 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
>>  	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code)
>>  }
>>  +void kvm_propagate_fault(struct kvm_vcpu *vcpu, unsigned long addr, 
>> u32 error_code)
>> +{
>> +	u32 nested, error;
>> +
>> +	nested = error_code &  PFERR_NESTED_MASK;
>> +	error  = error_code & ~PFERR_NESTED_MASK;
>> +
>> +	if (vcpu->arch.mmu.nested && !(error_code && PFERR_NESTED_MASK))
>
> This looks incorrect, nested is unused.
>
> At the very least it should be a binary & operation
>
> 	if (vcpu->arch.mmu.nested && !(error_code & PFERR_NESTED_MASK))
>
> which can be simplified to
>
> 	if (vcpu->arch.mmu.nested && !nested)
>
> but it seems wrong that the condition is that it is nested and not nested 
> at the same time.

Yes, this is already fixed in my local patch-stack. I found it during
further testing (while fixing another bug). But thanks for your feedback
:-)

	Joerg


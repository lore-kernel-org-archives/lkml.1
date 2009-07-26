Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZGZPT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZGZPT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 11:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZGZPTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 11:19:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37109 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbZGZPTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 11:19:25 -0400
Message-ID: <4A6C7504.40800@redhat.com>
Date: Sun, 26 Jul 2009 18:23:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kvm/x86/svm: force new asid on vcpu migration
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <1236255153-4432-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1236255153-4432-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2009 02:12 PM, Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1821c20..0e66bca 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -180,7 +180,7 @@ static inline void kvm_write_cr2(unsigned long val)
>
>   static inline void force_new_asid(struct kvm_vcpu *vcpu)
>   {
> -	to_svm(vcpu)->asid_generation--;
> +	to_svm(vcpu)->asid_generation = 0;
>   }
>
>   static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
> @@ -716,6 +716,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		svm->vmcb->control.tsc_offset += delta;
>   		vcpu->cpu = cpu;
>   		kvm_migrate_timers(vcpu);
> +		force_new_asid(vcpu);
>   	}
>
>   	for (i = 0; i<  NR_HOST_SAVE_USER_MSRS; i++)
>    

Does this remove the need for 6eaa802c ("KVM: SVM: fix random segfaults 
with NPT enabled")?

-- 
error compiling committee.c: too many arguments to function


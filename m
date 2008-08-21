Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYHUNu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYHUNu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYHUNut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:50:49 -0400
Received: from il.qumranet.com ([212.179.150.194]:42027 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbYHUNut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:50:49 -0400
Message-ID: <48AD72B7.3090608@qumranet.com>
Date: Thu, 21 Aug 2008 16:50:47 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM_GUEST: use the right parameter type on	kvm_release_pt()
 (was Re: i386 allmodconfig in linux-next)
References: <20080819024549.5f2c43cf.akpm@linux-foundation.org> <48AACD95.8050207@qumranet.com> <20080819191607.GQ6342@blackpad>
In-Reply-To: <20080819191607.GQ6342@blackpad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> From: Eduardo Habkost <ehabkost@redhat.com>
> Subject: [PATCH] KVM_GUEST: Use the right parameter type on kvm_release_pt()
>
> This fixes the following compiler warnings, that were introduced by me
> on commit fa24f8e67c189b8b904c8a34f12e6dae9c14dbba.
>
> arch/x86/kernel/kvm.c: In function 'paravirt_ops_setup':
> arch/x86/kernel/kvm.c:233: warning: assignment from incompatible pointer type
> arch/x86/kernel/kvm.c:234: warning: assignment from incompatible pointer type
> arch/x86/kernel/kvm.c:235: warning: assignment from incompatible pointer type
>   

Ingo?  Can you queue/fold this into the original patch?

> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  arch/x86/kernel/kvm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 8b7a3cf..478bca9 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -178,7 +178,7 @@ static void kvm_flush_tlb(void)
>  	kvm_deferred_mmu_op(&ftlb, sizeof ftlb);
>  }
>  
> -static void kvm_release_pt(u32 pfn)
> +static void kvm_release_pt(unsigned long pfn)
>  {
>  	struct kvm_mmu_op_release_pt rpt = {
>  		.header.op = KVM_MMU_OP_RELEASE_PT,
>   


-- 
error compiling committee.c: too many arguments to function


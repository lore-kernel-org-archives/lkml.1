Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYGEJnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYGEJnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 05:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYGEJnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 05:43:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:35459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYGEJnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 05:43:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,306,1212390000"; 
   d="scan'208";a="303049284"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH next-20080704] fix build error of arch/ia64/kvm/*
Date: Sat, 5 Jul 2008 17:43:09 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC015702DB@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <s5hskupltbz.wl%tiwai@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH next-20080704] fix build error of arch/ia64/kvm/*
Thread-Index: Acjd0qJ56l7gvQelSIqJSxQLeAERCwAsNU/Q
References: <s5hskupltbz.wl%tiwai@suse.de>
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: "Takashi Iwai" <tiwai@suse.de>, "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "Jens Axboe" <jens.axboe@oracle.com>, <linux-next@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Jul 2008 09:43:10.0522 (UTC) FILETIME=[894631A0:01C8DE83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by Xiantao Zhang <xiantao.zhang@intel.com>

Takashi Iwai wrote:
> Fix calls of smp_call_function*() in arch/ia64/kvm for recent API
> changes.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> index a4cf4a2..9408b30 100644
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -398,7 +398,7 @@ static int handle_global_purge(struct kvm_vcpu
>  		*vcpu, struct kvm_run *kvm_run) if (kvm->vcpus[i]->cpu
!= -1) {
>  			call_data.vcpu = kvm->vcpus[i];
>  			smp_call_function_single(kvm->vcpus[i]->cpu,
> -					vcpu_global_purge, &call_data,
0, 1);
> +					vcpu_global_purge, &call_data,
1);
>  		} else
>  			printk(KERN_WARNING"kvm: Uninit vcpu received
ipi!\n");
> 
> @@ -1688,7 +1688,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  		wake_up_interruptible(&vcpu->wq);
> 
>  	if (vcpu->guest_mode)
> -		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu,
0, 0);
> +		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu,
0);
>  }
> 
>  int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig)
> diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
> index 091f936..0c69d9e 100644
> --- a/arch/ia64/kvm/kvm_fw.c
> +++ b/arch/ia64/kvm/kvm_fw.c
> @@ -130,7 +130,7 @@ static struct ia64_pal_retval
>  	pal_cache_flush(struct kvm_vcpu *vcpu) args.cache_type = gr29;
>  	args.operation = gr30;
>  	smp_call_function(remote_pal_cache_flush,
> -				(void *)&args, 1, 1);
> +				(void *)&args, 1);
>  	if (args.status != 0)
>  		printk(KERN_ERR"pal_cache_flush error!,"
>  				"status:0x%lx\n", args.status);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZARS5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZARS5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZARS44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:56:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbZARS4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:56:54 -0500
Date: Sun, 18 Jan 2009 19:56:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>, Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090118185635.GA30514@elte.hu>
References: <1232287474.3130.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232287474.3130.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Avi Cc:-ed)

* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

>       headers_check fix: linux/kvm.h

> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 5715f19..5d004bc 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -58,12 +58,14 @@ struct kvm_irqchip {
>  	__u32 pad;
>          union {
>  		char dummy[512];  /* reserving space */
> +#ifdef __KERNEL__
>  #ifdef CONFIG_X86
>  		struct kvm_pic_state pic;
>  #endif
>  #if defined(CONFIG_X86) || defined(CONFIG_IA64)
>  		struct kvm_ioapic_state ioapic;
>  #endif
> +#endif /* __KERNEL__ */
>  	} chip;
>  };

Avi, does user-space need the kvm_irqchip definition from this header? If 
not then it would be cleaner to mark this whole structure as #ifdef 
__KERNEL__.

> @@ -384,18 +386,24 @@ struct kvm_trace_rec {
>  #define KVM_CAP_MP_STATE 14
>  #define KVM_CAP_COALESCED_MMIO 15
>  #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
> +#ifdef __KERNEL__
>  #if defined(CONFIG_X86)||defined(CONFIG_IA64)
>  #define KVM_CAP_DEVICE_ASSIGNMENT 17
>  #endif
> +#endif /* __KERNEL__ */
>  #define KVM_CAP_IOMMU 18
> +#ifdef __KERNEL__
>  #if defined(CONFIG_X86)
>  #define KVM_CAP_DEVICE_MSI 20
>  #endif
> +#endif /* __KERNEL__ */
>  /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
>  #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
> +#ifdef __KERNEL__
>  #if defined(CONFIG_X86)
>  #define KVM_CAP_USER_NMI 22
>  #endif
> +#endif /* __KERNEL__ */

likewise, are these bits really used by user-space KVM bits? If not then 
the whole thing could go into an #ifdef __KERNEL__ block.

	Ingo

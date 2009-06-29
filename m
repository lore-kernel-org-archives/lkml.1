Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZF2KWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZF2KWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbZF2KWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:22:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758856AbZF2KWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:22:40 -0400
Date: Mon, 29 Jun 2009 12:22:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       kvm@vger.kernel.org, avi@redhat.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v2] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090629102235.GA15372@elte.hu>
References: <20090629100837.GW20289@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629100837.GW20289@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gleb Natapov <gleb@redhat.com> wrote:

> KVM would like to provide x2APIC interface to a guest without emulating
> interrupt remapping device. The reason KVM prefers guest to use x2APIC
> is that x2APIC interface is better virtualizable and provides better
> performance than mmio xAPIC interface:
> 
> - msr exits are faster than mmio (no page table walk, emulation)
> - no need to read back ICR to look at the busy bit
> - one 64 bit ICR write instead of two 32 bit writes
> - shared code with the Hyper-V paravirt interface
> 
> Included patch changes x2APIC enabling logic to enable it even if IR
> initialization failed, but kernel runs under KVM and no apic id is
> greater than 255 (if there is one spec requires BIOS to move to x2apic
> mode before starting an OS).
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> ---
> 
> v2:
>   Add help message to Kconfig
>   Force physical mode if IR is not available.
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d1430ef..3e5b6ea 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -260,12 +260,15 @@ config SMP
>  
>  config X86_X2APIC
>  	bool "Support x2apic"
> -	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
> +	depends on X86_LOCAL_APIC && X86_64

Have you tried to build this with X86_X2APIC set but INTR_REMAP 
disabled?

	Ingo

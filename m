Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZC2Lyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZC2Lyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZC2Lyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:54:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54776 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZC2Lye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:54:34 -0400
Message-ID: <49CF6177.9010907@redhat.com>
Date: Sun, 29 Mar 2009 14:54:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] kvm x86: report 1GB page support to userspace
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-8-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1238164319-16092-8-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> If userspace knows that the kernel part supports 1GB pages it can enable
> the corresponding cpuid bit so that guests actually use GB pages.
>   

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a1df2a3..6593198 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -542,6 +542,8 @@ struct kvm_x86_ops {
>  	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>  	int (*get_tdp_level)(void);
>  	int (*get_mt_mask_shift)(void);
> +
> +	bool (*gb_page_enable)(void);
>  };
>   

Should enable unconditionally.  Of course we need to find the shadow bug 
first, may be the has_wrprotected thingy.

> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index ee755e2..e79eb26 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -413,6 +413,7 @@ struct kvm_trace_rec {
>  #define KVM_CAP_DEVICE_MSIX 28
>  #endif
>  #define KVM_CAP_ASSIGN_DEV_IRQ 29
> +#define KVM_CAP_1GB_PAGES 30
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
>   

Need KVM_GET_SUPPORTED_CPUID2 support as well.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZELSLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZELSLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZELSLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:11:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53616 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZELSLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:11:22 -0400
Message-ID: <4A09BBCC.80801@redhat.com>
Date: Tue, 12 May 2009 21:11:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 1/2] replace drop_interrupt_shadow by set_interrupt_shadow
References: <1242141230-22514-1-git-send-email-glommer@redhat.com> <1242141230-22514-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1242141230-22514-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> This patch replaces drop_interrupt_shadow with the more
> general set_interrupt_shadow, that can either drop or raise
> it, depending on its parameter.
>
>  }
>  
> +static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 ret = 0;
> +
> +	if (svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
> +		ret |= X86_SHADOW_INT_STI && X86_SHADOW_INT_MOV_SS;
> +	return ret & mask;
> +}
>   

&& -> |.

> +
> +static void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
> +{
> +	u32 interruptibility_old = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> +	u32 interruptibility = interruptibility_old;
> +
> +	interruptibility &= ~((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
>   

May drop one layer of parentheses.



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


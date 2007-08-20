Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbXHTNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbXHTNka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbXHTNkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:40:16 -0400
Received: from il.qumranet.com ([82.166.9.18]:52141 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693AbXHTNkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:40:13 -0400
Message-ID: <46C999C8.4080307@qumranet.com>
Date: Mon, 20 Aug 2007 16:40:24 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Ingo Molnar <mingo@elte.hu>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH 4/4] Modify KVM to update guest time accounting.
References: <46C993A6.3060001@bull.net>
In-Reply-To: <46C993A6.3060001@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> [PATCH 4/4] Modify KVM to update guest time accounting.
>
>   

> Index: kvm/drivers/kvm/kvm.h
> ===================================================================
> --- kvm.orig/drivers/kvm/kvm.h	2007-08-20 13:23:53.000000000 +0200
> +++ kvm/drivers/kvm/kvm.h	2007-08-20 13:23:58.000000000 +0200
> @@ -589,6 +589,17 @@ void kvm_mmu_unload(struct kvm_vcpu *vcp
>  
>  int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
> +static inline void kvm_guest_enter(void)
> +{
> +#ifdef CONFIG_GUEST_ACCOUNTING
> +	current->flags |= PF_VCPU;
> +#endif
>   

Since you select GUEST_ACCOUNTING, the #ifdef is always true?

> +}
> +
> +static inline void kvm_guest_exit(void)
> +{
>   

Missing content?

-- 
error compiling committee.c: too many arguments to function


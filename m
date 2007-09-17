Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbXIQQRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbXIQQRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXIQQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:17:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4484 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbXIQQRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:17:04 -0400
Subject: Re: [PATCH 048/104] KVM: Add and use pr_unimpl for standard
	formatting of unimplemented features
From: Joe Perches <joe@perches.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <11900179481707-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
	 <11900179481707-git-send-email-avi@qumranet.com>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 09:16:18 -0700
Message-Id: <1190045778.19708.211.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 10:31 +0200, Avi Kivity wrote:
> diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
> index cfda3ab..6d25826 100644
> --- a/drivers/kvm/kvm.h
> +++ b/drivers/kvm/kvm.h
> @@ -474,6 +474,14 @@ struct kvm_arch_ops {
>  
>  extern struct kvm_arch_ops *kvm_arch_ops;
>  
> +/* The guest did something we don't support. */
> +#define pr_unimpl(vcpu, fmt, ...)					\
> + do {									\
> +	if (printk_ratelimit())						\
> +		printk(KERN_ERR "kvm: %i: cpu%i " fmt,			\
> +		       current->tgid, (vcpu)->vcpu_id , ## __VA_ARGS__); \
> + } while(0)
> +
>  #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
>  #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
>  

This converts all KERN_<level> uses to KERN_ERR.
It seems better to add a <level> argument to kvm_printf.
pr_unimpl is perhaps a poor name choice.
perhaps vcpu_printk_ratelimit(vcpu, level, fmt, ...)



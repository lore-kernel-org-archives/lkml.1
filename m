Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZEFIDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZEFIDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZEFID0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:03:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZEFIDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:03:24 -0400
Date: Wed, 6 May 2009 11:03:21 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated
	instruction
Message-ID: <20090506080321.GU9795@redhat.com>
References: <1241548811-8138-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241548811-8138-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 02:40:11PM -0400, Glauber Costa wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8e680c3..a49d07b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -510,6 +510,8 @@ struct kvm_x86_ops {
>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
There is .drop_interrupt_shadow() callback. The patch should remove it and
replace its use by set_interrupt_shadow().

--
			Gleb.

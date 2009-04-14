Return-Path: <linux-kernel-owner+w=401wt.eu-S1751154AbZDNJH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbZDNJH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZDNJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:07:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53821 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZDNJHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:07:12 -0400
Date: Tue, 14 Apr 2009 12:07:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated
	instruction
Message-ID: <20090414090703.GV25543@redhat.com>
References: <1239653210-10422-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239653210-10422-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 04:06:50PM -0400, Glauber Costa wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3fc4623..0db1be7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -513,6 +513,7 @@ struct kvm_x86_ops {
>  	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
>  	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +	void (*interrupt_shadow_mask)(struct kvm_vcpu *vcpu, int mask);

Note that this conflicts with my "Move interrupt injection logic to x86.c"
patch. It adds drop_interrupt_shadow callback. Your callback is more
general so it should replace mine when/if my patchset will go in.

--
			Gleb.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZG2NPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZG2NPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZG2NPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:15:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZG2NPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:15:11 -0400
Message-ID: <4A704B5F.5000206@suse.de>
Date: Wed, 29 Jul 2009 15:15:11 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] kvm/svm: add helper functions for global interrupt
 flag
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |   31 +++++++++++++++++++++++--------
>  1 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 27d26c3..9f69b25 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -136,6 +136,21 @@ static inline bool is_nested(struct vcpu_svm *svm)
>  	return svm->nested_vmcb;
>  }
>  
> +static inline void enable_gif(struct vcpu_svm *svm)
> +{
> +	svm->vcpu.arch.hflags |= HF_GIF_MASK;
> +}
> +
> +static inline void disable_gif(struct vcpu_svm *svm)
> +{
> +	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
> +}
> +
> +static inline bool gif_set(struct vcpu_svm *svm)
> +{
> +	return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
> +}
> +
>  static unsigned long iopm_base;
>  
>  struct kvm_ldttss_desc {
> @@ -630,7 +645,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>  	force_new_asid(&svm->vcpu);
>  
>  	svm->nested_vmcb = 0;
> -	svm->vcpu.arch.hflags = HF_GIF_MASK;
> +	enable_gif(svm);
>   

Are we sure hflags is always 0 here?


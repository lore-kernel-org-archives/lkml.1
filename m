Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZBYQOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZBYQOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZBYQOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:14:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60675 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbZBYQOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:14:35 -0500
Date: Wed, 25 Feb 2009 13:13:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm x86: release time_page on vcpu destruction
Message-ID: <20090225161352.GA6707@amt.cnet>
References: <1235574511-4571-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235574511-4571-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 04:08:31PM +0100, Joerg Roedel wrote:
> Not releasing the time_page causes a leak of that page or the compound
> page it is situated in.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/x86.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8ca100a..a1ecec5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4159,6 +4159,11 @@ EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
>  
>  void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
>  {
> +	if (vcpu->arch.time_page) {
> +		kvm_release_page_dirty(vcpu->arch.time_page);
> +		vcpu->arch.time_page = NULL;
> +	}
> +
>  	kvm_x86_ops->vcpu_free(vcpu);
>  }

Looks good.


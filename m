Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZG2Nul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZG2Nul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZG2Nuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:50:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbZG2Nuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:50:39 -0400
Message-ID: <4A7053AF.60301@suse.de>
Date: Wed, 29 Jul 2009 15:50:39 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kvm/svm: cache nested intercepts
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-9-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248872192-30881-9-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |   30 +++++++++++++++++++++++-------
>  1 files changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 31467b1..9192c9a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -86,6 +86,15 @@ struct nested_state {
>  
>  	/* gpa pointers to the real vectors */
>  	u64 vmcb_msrpm;
> +
> +	/* cache for intercepts of the guest */
> +	u16 intercept_cr_read;
> +	u16 intercept_cr_write;
> +	u16 intercept_dr_read;
> +	u16 intercept_dr_write;
> +	u32 intercept_exceptions;
> +	u64 intercept;
> +
>  };
>  
>  struct vcpu_svm {
> @@ -1459,7 +1468,6 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
>  					void *arg2,
>  					void *opaque)
>  {
> -	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
>   

That's not enough. You actually have to make the caller not pass it as
argument too. Otherwise a good idea.


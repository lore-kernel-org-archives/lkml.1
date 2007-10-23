Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbXJWWoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbXJWWoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXJWWob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:44:31 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40364 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752367AbXJWWoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:44:30 -0400
Date: Wed, 24 Oct 2007 00:44:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       avi@qumranet.com
Subject: Re: [PATCH 6/12] KVM: work around SMP requirement
Message-ID: <20071023224455.GY30533@stusta.de>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071023223640.EADF31F81AC@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 06:36:40PM -0400, Jeff Garzik wrote:
> KVM is currently completely broken for the !CONFIG_SMP case.
> 
> drivers/kvm/kvm_main.c: In function ‘kvm_flush_remote_tlbs’:
> drivers/kvm/kvm_main.c:220: error: implicit declaration of function ‘smp_call_function_mask’
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> I hope the KVM maintainer can come up with a better solution...
> 
> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
> index 8749fa4..e35fbc6 100644
> --- a/drivers/kvm/Kconfig
> +++ b/drivers/kvm/Kconfig
> @@ -16,7 +16,7 @@ if VIRTUALIZATION
>  
>  config KVM
>  	tristate "Kernel-based Virtual Machine (KVM) support"
> -	depends on X86 && EXPERIMENTAL
> +	depends on X86 && EXPERIMENTAL && SMP
>...

Assuming it won't get fixed soon, the pattern would be "(SMP || BROKEN)".

The effect is the same, but this makes it more obvious that KVM 
does not depend architecturally on SMP but just broken.

Of course, the preferred solution is to simply get KVM fixed...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


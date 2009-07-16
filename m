Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbZGPPaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbZGPPaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbZGPPaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:30:22 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52711 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbZGPPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:30:21 -0400
Date: Thu, 16 Jul 2009 17:30:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com, aliguori@us.ibm.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external
	interaction with guests
Message-ID: <20090716153019.GA5727@merkur.ravnborg.org>
Mail-Followup-To: Gregory Haskins <ghaskins@novell.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
	glommer@redhat.com, aliguori@us.ibm.com
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716151945.29318.10882.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
> index ad8ec35..9f50cc3 100644
> --- a/arch/x86/Kbuild
> +++ b/arch/x86/Kbuild
> @@ -1,5 +1,7 @@
>  
> -obj-$(CONFIG_KVM) += kvm/
> +ifdef CONFIG_KVM
> +obj-y += kvm/
> +endif

What was wrong with the old version?
If this is because xinterface.o is builtin to the kernel then we should
always visit kvm/ and use:

   obj-y += kvm/

unconditionally.



>  
>  # Xen paravirtualization support
>  obj-$(CONFIG_XEN) += xen/
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index afaaa76..80d951d 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -17,3 +17,7 @@ kvm-amd-y		+= svm.o
>  obj-$(CONFIG_KVM)	+= kvm.o
>  obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
>  obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
> +
> +ifdef CONFIG_KVM
> +obj-y += $(addprefix ../../../virt/kvm/, xinterface.o)
> +endif
And when we always visit kvm/ the above code snippet makes sense.
Before we never visited kvm/ unless CONFIG_KVM was defined.

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbXJQT1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbXJQT1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXJQT1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:27:22 -0400
Received: from www.tglx.de ([62.245.132.106]:33090 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXJQT1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:27:21 -0400
Date: Wed, 17 Oct 2007 21:26:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix kernel rebuild due to vsyscall fallout
In-Reply-To: <20071017191633.GB11837@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.9999.0710172126110.24155@localhost.localdomain>
References: <4715F2E5.6000104@panasas.com> <20071017191633.GB11837@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Sam Ravnborg wrote:

> Fix rebuild of kernel when there is no changes.
> This happened for i386.
> Using make V=2 hinted that the output files were
> not assigned to targets - fixed by this patch.
> 
> Reported by: Boaz Harrosh <bharrosh@panasas.com>
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
> index 7ff0206..a3fa11f 100644
> --- a/arch/x86/kernel/Makefile_32
> +++ b/arch/x86/kernel/Makefile_32
> @@ -51,7 +51,7 @@ obj-$(CONFIG_SCx200)		+= scx200_32.o
>  # We must build both images before we can assemble it.
>  # Note: kbuild does not track this dependency due to usage of .incbin
>  $(obj)/vsyscall_32.o: $(obj)/vsyscall-int80_32.so $(obj)/vsyscall-sysenter_32.so
> -targets += $(foreach F,int80 sysenter,vsyscall-$F.o vsyscall-$F.so)
> +targets += $(foreach F,int80 sysenter,vsyscall-$F_32.o vsyscall-$F_32.so)
>  targets += vsyscall-note_32.o vsyscall_32.lds
>  
>  # The DSO images are built using a special linker script.

Thanks, applied

	tglx

 

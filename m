Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbXKUL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbXKUL7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXKUL7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:59:11 -0500
Received: from www.tglx.de ([62.245.132.106]:52304 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbXKUL7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:59:10 -0500
Date: Wed, 21 Nov 2007 12:58:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: TLS cleanup
In-Reply-To: <20071121102511.08B8A26F8BE@magilla.localdomain>
Message-ID: <alpine.LFD.0.9999.0711211253470.25057@localhost.localdomain>
References: <20071121101928.A08CF26F8BE@magilla.localdomain> <20071121102511.08B8A26F8BE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Roland McGrath wrote:

> 
> This consolidates the four different places that implemented the same
> encoding magic for the GDT-slot 32-bit TLS support.  The old tls32.c is
> renamed and only slightly modified to be the shared implementation guts.

Cool patchset. 

One minor nit: Please do not put stuff into proto.h anymore. I'm
desperately trying to get rid of it.

> diff --git a/include/asm-x86/proto.h b/include/asm-x86/proto.h
> index dabba55..a7aa17d 100644
> --- a/include/asm-x86/proto.h
> +++ b/include/asm-x86/proto.h
> @@ -24,6 +24,11 @@ extern void ia32_syscall(void);
>  extern void ia32_cstar_target(void); 
>  extern void ia32_sysenter_target(void); 
>  
> +extern int do_get_thread_area(struct task_struct *p, int idx,
> +			      struct user_desc __user *info);
> +extern int do_set_thread_area(struct task_struct *p, int idx,
> +			      struct user_desc __user *info, int can_allocate);
> +
>  extern void config_acpi_tables(void);
>  extern void ia32_syscall(void);

I pull it into the x86 git tree and look for a better place for
do_[sg]et_thread_area()

Thanks,

	tglx

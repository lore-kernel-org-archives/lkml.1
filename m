Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbYAOM65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbYAOM65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbYAOM6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:58:47 -0500
Received: from saeurebad.de ([85.214.36.134]:60014 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbYAOM6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:58:46 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [4/31] Add pte_pgprot on i386
References: <200801141116.534682000@suse.de>
	<20080114221636.0306F14F83@wotan.suse.de>
Date: Tue, 15 Jan 2008 14:00:00 +0100
In-Reply-To: <20080114221636.0306F14F83@wotan.suse.de> (Andi Kleen's message
	of "Mon, 14 Jan 2008 23:16:35 +0100 (CET)")
Message-ID: <87zlv7fdm7.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi Kleen <ak@suse.de> writes:

[...]
> --- linux.orig/include/asm-x86/pgtable-2level.h
> +++ linux/include/asm-x86/pgtable-2level.h
> @@ -75,6 +75,8 @@ static inline int pte_exec_kernel(pte_t 
>  #define pgoff_to_pte(off) \
>  	((pte_t) { .pte_low = (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
>  
> +#define pte_pgprot(x) __pgprot((x).pte_low & 0xfff)

[...]

> --- linux.orig/include/asm-x86/pgtable-3level.h
> +++ linux/include/asm-x86/pgtable-3level.h
> @@ -142,6 +142,8 @@ static inline unsigned long pte_pfn(pte_
>  	return pte_val(pte) >> PAGE_SHIFT;
>  }
>  
> +#define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))

Could we use pte_val() in both cases?

	Hannes

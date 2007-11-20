Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXKTDUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXKTDUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbXKTDUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:20:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbXKTDUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:20:46 -0500
From: Andi Kleen <ak@suse.de>
To: clameter@sgi.com
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Tue, 20 Nov 2007 04:16:32 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <20071120011333.619991903@sgi.com>
In-Reply-To: <20071120011333.619991903@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711200416.32954.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 4k cpu configurations with 1k nodes:
>
> 	4096 * 16MB = 64TB of virtual space.
>
> Maximum theoretical configuration 16384 processors 1k nodes:
>
> 	16384 * 16MB = 256TB of virtual space.
>
> Both fit within the established limits established.

I might be pointing out the obvious, but on x86-64 there is definitely not 
256TB of VM available for this.

Not even 64TB, as long as you want to have any
other mappings in kernel (total kernel memory 128TB, but it is split in
half for the direct mapping) 

BTW if you allocate any VM you should also update
Documentation/x86_64/mm.txt which describes the mapping

> Index: linux-2.6/include/asm-x86/pgtable_64.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/pgtable_64.h	2007-11-19
> 15:45:07.638390147 -0800 +++
> linux-2.6/include/asm-x86/pgtable_64.h	2007-11-19 15:55:53.165640248 -0800
> @@ -138,6 +138,7 @@ static inline pte_t ptep_get_and_clear_f
>  #define VMALLOC_START    _AC(0xffffc20000000000, UL)
>  #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
>  #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
> +#define CPU_AREA_BASE	 _AC(0xffffffff84000000, UL)

That's slightly less than 1GB before you bump into the maximum.
But you'll bump into the module mapping even before that.

For 16MB/CPU and the full 1GB that's ~123 CPUs if my calculations are correct. 
Even for a  not Altix that's quite tight.

I suppose 16MB/CPU are too large.

-Andi

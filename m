Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXIWBbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXIWBbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbXIWBbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:31:25 -0400
Received: from barikada.upol.cz ([158.194.242.200]:40688 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXIWBbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:31:25 -0400
To: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [20/50] x86_64: Fix some broken white space in arch/x86_64/mm/init.c
In-Reply-To: <1190488676.4035.96.camel@chaos>
References: <200709221231.836138000@suse.de> <20070921223219.30ADD13DCD@wotan.suse.de> <1190488676.4035.96.camel@chaos>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sun, 23 Sep 2007 03:47:03 +0200
Message-Id: <E1IZGYp-0003xA-5W@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Much, much better :)

> -static void __meminit phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
> -{

+static void __meminit phys_pud_init(pud_t *pud_page, ulong addr, ulong end)

If somebody have *strong* objections, please say so.

[]
> @@ -737,7 +750,7 @@ int in_gate_area_no_task(unsigned long addr)
>  void * __init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
>  {
>  	return __alloc_bootmem_core(pgdat->bdata, size,
> -			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
> +				    SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
>  }

Maybe just?

+	return __alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, 1UL << 32, 0);

(87 is alright sometimes)
_____

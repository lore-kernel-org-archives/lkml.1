Return-Path: <linux-kernel-owner+w=401wt.eu-S934660AbXKPBAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbXKPBAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 20:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933310AbXKPBAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 20:00:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932394AbXKPBAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 20:00:16 -0500
Date: Thu, 15 Nov 2007 16:59:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       apw@shadowen.org, kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [3/3] fix
 section mismatch in init_memory_mapping
Message-Id: <20071115165935.b71dab7a.akpm@linux-foundation.org>
In-Reply-To: <20071115193639.7c170e57.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193639.7c170e57.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 19:36:39 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> Changes __meminit to __init_refok.
> ==
> WARNING: vmlinux.o(.text+0x1d07c): Section mismatch: reference to
> .init.text:find_e820_area (between 'init_memory_mapping' and 'arch_add_memory')
> ==
> 
> Changelog:
>  * changes __init_refok from find_early_table_space() to
>    init_memory_mapping().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
>  arch/x86/mm/init_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.24-rc2-mm1.orig/arch/x86/mm/init_64.c
> +++ linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
> @@ -347,7 +347,7 @@ static void __init find_early_table_spac
>  /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
>     This runs before bootmem is initialized and gets pages directly from the 
>     physical memory. To access them they are temporarily mapped. */
> -void __meminit init_memory_mapping(unsigned long start, unsigned long end)
> +void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
>  { 
>  	unsigned long next; 
>  

again, I _think_ this fixes a bug in mainline.  Can you check that please?

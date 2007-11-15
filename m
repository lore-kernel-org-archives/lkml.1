Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbXKOI5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbXKOI5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXKOI5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:57:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756260AbXKOI5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:57:40 -0500
Date: Thu, 15 Nov 2007 00:56:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc2-mm1 (memory hotplug x86_64/vmemmap  fix)
Message-Id: <20071115005657.99856c28.akpm@linux-foundation.org>
In-Reply-To: <20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 13:29:19 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Fixes for memory hotplug compile and .section handling.
> 
> This patch fixes following bugs
> ==
> WARNING: vmlinux.o(.text+0x1d07c): Section mismatch: reference to .init.text:f
> ind_e820_area (between 'init_memory_mapping' and 'arch_add_memory')
> WARNING: vmlinux.o(.text+0x946b5): Section mismatch: reference to .init.text:
> __alloc_bootmem_node (between 'vmemmap_alloc_block' and 'vmemmap_pgd_populate')
> 
> ERROR: "memory_add_physaddr_to_nid" [drivers/acpi/acpi_memhotplug.ko] undefined!
> make[1]: *** [__modpost
> ==
> 
> This patch does
>  1. export memory_add_physaddr_to_nid().
>  2. changes __init to __init_refok find_early_table_space() (x86/mm/init_64.c)
>  3. changes __init_refok to __meminit in mm/sparse.c (This is bug.)
>  4. add wrapper function to call bootmem allocator without warning.
> 
>  After seeing "3", I thought simple __init_refok is dangerous and decided to
>  add wrapper function to call bootmem, is this style acceptable ?

eek.

What I now need to do with this patch is

- Work out which patches in -mm it is actually fixing.

- If that is more than one patch then split this patch up into multiple ones.

- Stage the one or more fixup patches immediately after the patches which
  they are fixing (with appropriate names: foo-fix.patch fixes foo.patch)

And that's OK - it's what I do.  But if you already have some idea which
patch you're actually fixing then it really helps me if you can tell me
which one it was, please - there's no point in having me duplicate your
work.

Plus it does look like this is three patches in one (at least)...

Thanks.

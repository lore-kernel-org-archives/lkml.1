Return-Path: <linux-kernel-owner+w=401wt.eu-S1763708AbXKOKf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708AbXKOKf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbXKOKfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:35:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38761 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbXKOKfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:35:13 -0500
Date: Thu, 15 Nov 2007 19:36:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [3/3] fix section
 mismatch in init_memory_mapping
Message-Id: <20071115193639.7c170e57.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Changes __meminit to __init_refok.
==
WARNING: vmlinux.o(.text+0x1d07c): Section mismatch: reference to
.init.text:find_e820_area (between 'init_memory_mapping' and 'arch_add_memory')
==

Changelog:
 * changes __init_refok from find_early_table_space() to
   init_memory_mapping().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/arch/x86/mm/init_64.c
+++ linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
@@ -347,7 +347,7 @@ static void __init find_early_table_spac
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
    This runs before bootmem is initialized and gets pages directly from the 
    physical memory. To access them they are temporarily mapped. */
-void __meminit init_memory_mapping(unsigned long start, unsigned long end)
+void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
 { 
 	unsigned long next; 
 


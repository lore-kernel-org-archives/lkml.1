Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbXG1GON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbXG1GON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXG1GN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:13:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38476 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbXG1GNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:13:55 -0400
Date: Sat, 28 Jul 2007 15:14:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>, Zoltan.Menyhart@bull.net,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] flush icache before set_pte() take 5. [1/2] cache flush in
 migration
Message-Id: <20070728151449.f3ec0ebe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070728150319.d19f531f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070728150319.d19f531f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In migration, a new page should be cache flushed before set_pte()
in some archs which have virtually-tagged cache..

V4 -> V5:
   * changed flush_icache_page to flush_cache_page.

Signed-Off-By: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.23-rc1.test/mm/migrate.c
===================================================================
--- linux-2.6.23-rc1.test.orig/mm/migrate.c
+++ linux-2.6.23-rc1.test/mm/migrate.c
@@ -172,6 +172,7 @@ static void remove_migration_pte(struct 
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
+	flush_cache_page(vma, addr, pte_pfn(pte));
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageAnon(new))


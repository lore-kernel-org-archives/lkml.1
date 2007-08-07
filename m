Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbXHGIZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbXHGIZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbXHGIZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:25:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38673 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbXHGIZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:25:39 -0400
Date: Tue, 7 Aug 2007 17:26:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "Zoltan.Menyhart@bull.net" <Zoltan.Menyhart@bull.net>
Subject: [BUGFIX][PATCH] flush icache before set_pte() in ia64 take7, [1/2]
 migration fix
Message-Id: <20070807172648.4590c3dd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070807172458.59931ef2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070807172458.59931ef2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In migration, a new page should be cache flushed before set_pte()
in some archs which have virtually-tagged cache..

V6 -> V7:
   * adjusted against .2.6.23-rc2.

V5 -> V6:
   * no changes (added new patches to the patch set)
V4 -> V5:
   * changed flush_icache_page to flush_cache_page.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.23-rc2.test/mm/migrate.c
===================================================================
--- linux-2.6.23-rc2.test.orig/mm/migrate.c
+++ linux-2.6.23-rc2.test/mm/migrate.c
@@ -171,6 +171,7 @@ static void remove_migration_pte(struct 
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
+	flush_cache_page(vma, addr, pte_pfn(pte));
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageAnon(new))


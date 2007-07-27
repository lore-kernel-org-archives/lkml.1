Return-Path: <linux-kernel-owner+w=401wt.eu-S934597AbXG0EiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbXG0EiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXG0EiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:38:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40834 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXG0EiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:38:07 -0400
Date: Fri, 27 Jul 2007 13:38:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Zoltan.Menyhart@bull.net, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] flush cache fixes for ia64 [1/2] migration fix
Message-Id: <20070727133843.6cd3f57a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In migration, a new page should be cache flushed before set_pte()
in some archs.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

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
+	flush_icache_page(vma, new);
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageAnon(new))


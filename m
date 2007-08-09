Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXHIEyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXHIEyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXHIEyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:54:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34261 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXHIEyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:54:46 -0400
Date: Thu, 9 Aug 2007 13:56:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>, davem@davemloft.net,
       "Zoltan.Menyhart@bull.net" <Zoltan.Menyhart@bull.net>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: [PATCH] flush icache before set_pte() on ia64  take9 [1/2]
 migration fix
Message-Id: <20070809135608.ff3b0373.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In migration, a new page should be cache flushed before set_pte()
in some archs which have virtually-tagged cache..
I'll separate this from patch set in the next time.


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


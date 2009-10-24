Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZJXBIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZJXBIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZJXBIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:08:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:51715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbZJXBEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:42 -0400
Date: Sat, 24 Oct 2009 01:04:12 GMT
From: tip-bot for Minchan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yhlu.kernel@gmail.com, minchan.kim@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       minchan.kim@gmail.com, yhlu.kernel@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091022112722.adc8e55c.minchan.kim@barrios-desktop>
References: <20091022112722.adc8e55c.minchan.kim@barrios-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86: Remove pfn in add_one_highpage_init()
Message-ID: <tip-b1258ac2963d42ee7e807d2993d15e3dd39ff4b0@git.kernel.org>
Git-Commit-ID: b1258ac2963d42ee7e807d2993d15e3dd39ff4b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1258ac2963d42ee7e807d2993d15e3dd39ff4b0
Gitweb:     http://git.kernel.org/tip/b1258ac2963d42ee7e807d2993d15e3dd39ff4b0
Author:     Minchan Kim <minchan.kim@gmail.com>
AuthorDate: Thu, 22 Oct 2009 11:27:22 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 13:39:26 +0200

x86: Remove pfn in add_one_highpage_init()

commit cc9f7a0ccf000d4db5fbdc7b0ae48eefea102f69 changed
add_one_highpage_init. We don't use pfn any more.
Let's remove unnecessary argument.

This patch doesn't chage function behavior.
This patch is based on v2.6.32-rc5.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
LKML-Reference: <20091022112722.adc8e55c.minchan.kim@barrios-desktop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5e32b07..f64d0d5 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -412,7 +412,7 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
 	pkmap_page_table = pte;
 }
 
-static void __init add_one_highpage_init(struct page *page, int pfn)
+static void __init add_one_highpage_init(struct page *page)
 {
 	ClearPageReserved(page);
 	init_page_count(page);
@@ -445,7 +445,7 @@ static int __init add_highpages_work_fn(unsigned long start_pfn,
 		if (!pfn_valid(node_pfn))
 			continue;
 		page = pfn_to_page(node_pfn);
-		add_one_highpage_init(page, node_pfn);
+		add_one_highpage_init(page);
 	}
 
 	return 0;

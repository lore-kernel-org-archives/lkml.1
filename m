Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZJVC3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZJVC3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZJVC3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:29:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51455 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZJVC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=bK0GHgqwqDsfiCyo25pRO7DYyBYFkGvjOiEdfYj8It8K8iREoz42O8sjPK4UlSLAce
         PHghlXhccpVpYxPg/bQEGyIuSAY2WQxFiToK7nO/KgQetBIao1iENsm2k/ESucwXXT6o
         ARyWY0Tj+aI6XrCryvyLlOoxjXmba3R2y+q7I=
Date: Thu, 22 Oct 2009 11:27:22 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove pfn in add_one_highpage_init
Message-Id: <20091022112722.adc8e55c.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit cc9f7a0ccf000d4db5fbdc7b0ae48eefea102f69 changed add_one_highpage_init.
We don't use pfn any more. 
Let's remove unnecessary argument.

This patch doesn't chage function behavior.
This patch is based on v2.6.32-rc5.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 30938c1..d70269c 100644
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



-- 
Kind regards,
Minchan Kim

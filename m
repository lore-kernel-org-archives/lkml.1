Return-Path: <linux-kernel-owner+w=401wt.eu-S933969AbZHEJnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbZHEJnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933018AbZHEJnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:43:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60625 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbZHEJnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:43:06 -0400
Message-ID: <4A79540D.6060207@cn.fujitsu.com>
Date: Wed, 05 Aug 2009 17:42:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Matias Zabaljauregui <zabaljauregui@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Atsushi SAKAI <sakaia@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org
Subject: [PATCH] lguest: cleanup for map_switcher()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use alloc_page() instead of get_zeroed_page() and virt_to_page()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 drivers/lguest/core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 1e2cb84..b639019 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -67,12 +67,11 @@ static __init int map_switcher(void)
 	 * so we make sure they're zeroed.
 	 */
 	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++) {
-		unsigned long addr = get_zeroed_page(GFP_KERNEL);
-		if (!addr) {
+		switcher_page[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
+		if (!switcher_page[i])
 			err = -ENOMEM;
 			goto free_some_pages;
 		}
-		switcher_page[i] = virt_to_page(addr);
 	}
 
 	/*
-- 
1.6.1.2


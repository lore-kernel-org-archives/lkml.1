Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbZGQAIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbZGQAIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933792AbZGQAIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:08:01 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39130 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685AbZGQAF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 13/21] Blackfin: drop duplicate runtime checking of anomaly 05000448
Date: Thu, 16 Jul 2009 20:05:38 -0400
Message-Id: <1247789146-18786-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

We already catch this anomaly at compile time, and the runtime version is
such that it ends up checking on all parts rather than just the ones that
might actually have it.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index e4d2da7..98c2f79 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -937,10 +937,6 @@ void __init setup_arch(char **cmdline_p)
 			       CPU, bfin_revid());
 	}
 
-	/* We can't run on BF548-0.1 due to ANOMALY 05000448 */
-	if (bfin_cpuid() == 0x27de && bfin_revid() == 1)
-		panic("You can't run on this processor due to 05000448");
-
 	printk(KERN_INFO "Blackfin Linux support by http://blackfin.uclinux.org/\n");
 
 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu MHz System Clock\n",
-- 
1.6.3.3


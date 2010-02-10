Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0BJJWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:22:19 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39201 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0BJJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:22:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 29/35] radix: move radix init early
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to use it in early_irq_init()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 4cb47a1..8451878 100644
--- a/init/main.c
+++ b/init/main.c
@@ -584,6 +584,7 @@ asmlinkage void __init start_kernel(void)
 		local_irq_disable();
 	}
 	rcu_init();
+	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
@@ -657,7 +658,6 @@ asmlinkage void __init start_kernel(void)
 	proc_caches_init();
 	buffer_init();
 	key_init();
-	radix_tree_init();
 	security_init();
 	vfs_caches_init(totalram_pages);
 	signals_init();
-- 
1.6.4.2


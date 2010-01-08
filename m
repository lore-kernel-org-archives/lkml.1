Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442Ab0AHXsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0AHXsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191Ab0AHXrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:47:47 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44855 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab0AHXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:47:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 08 Jan 2010 15:46:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/5] radix: move radix init early
In-reply-to: <1262994393-17391-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1262994393-17391-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262994393-17391-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to use it in early_irq_init()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -584,6 +584,7 @@ asmlinkage void __init start_kernel(void
 		local_irq_disable();
 	}
 	rcu_init();
+	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
@@ -659,7 +660,6 @@ asmlinkage void __init start_kernel(void
 	key_init();
 	security_init();
 	vfs_caches_init(totalram_pages);
-	radix_tree_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();

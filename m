Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798Ab0AVJ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0AVJ2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678Ab0AVJ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:28:04 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46224 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0AVJZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:25:57 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 01:24:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 31/38] radix: move radix init early
In-reply-to: <1264152287-13866-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264152287-13866-32-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264152287-13866-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to use it in early_irq_init()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index dac44a9..8451878 100644
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
@@ -659,7 +660,6 @@ asmlinkage void __init start_kernel(void)
 	key_init();
 	security_init();
 	vfs_caches_init(totalram_pages);
-	radix_tree_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();
-- 
1.6.4.2


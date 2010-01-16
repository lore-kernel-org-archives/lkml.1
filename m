Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab0APDLg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830Ab0APDLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:11:33 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33964 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab0APDIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:06:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 28/37] radix: move radix init early
In-reply-to: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263611228-6751-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
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


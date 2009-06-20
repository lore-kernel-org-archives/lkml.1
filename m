Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbZFTSq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbZFTSq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbZFTSpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:45 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48031 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbZFTSpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 06/25] Blackfin: only build show_interrupts() when procfs is enabled
Date: Sat, 20 Jun 2009 14:44:29 -0400
Message-Id: <1245523488-26536-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/irqchip.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 36bba30..8abb642 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -54,6 +54,7 @@ static struct irq_desc bad_irq_desc = {
 #error "Blackfin architecture does not support CONFIG_CPUMASK_OFFSTACK."
 #endif
 
+#ifdef CONFIG_PROC_FS
 int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;
@@ -85,6 +86,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 	return 0;
 }
+#endif
 
 /*
  * do_IRQ handles all hardware IRQs.  Decoded IRQs should not
-- 
1.6.3.1


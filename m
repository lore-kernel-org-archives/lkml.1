Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbZINUOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbZINUOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbZINUOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:14:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54154 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933639AbZINUI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 55/72] Blackfin: handle the core timer interrupt with handle_percpu_irq on SMP
Date: Mon, 14 Sep 2009 16:07:59 -0400
Message-Id: <1252958896-25150-56-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/ints-priority.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 4cc55bc..6ffda78 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -1052,18 +1052,26 @@ int __init init_arch_irq(void)
 			set_irq_chained_handler(irq, bfin_demux_error_irq);
 			break;
 #endif
+
 #ifdef CONFIG_SMP
+#ifdef CONFIG_TICKSOURCE_GPTMR0
+		case IRQ_TIMER0:
+#endif
+#ifdef CONFIG_TICKSOURCE_CORETMR
+		case IRQ_CORETMR:
+#endif
 		case IRQ_SUPPLE_0:
 		case IRQ_SUPPLE_1:
 			set_irq_handler(irq, handle_percpu_irq);
 			break;
 #endif
+
 #ifdef CONFIG_IPIPE
 #ifndef CONFIG_TICKSOURCE_CORETMR
 		case IRQ_TIMER0:
 			set_irq_handler(irq, handle_simple_irq);
 			break;
-#endif /* !CONFIG_TICKSOURCE_CORETMR */
+#endif
 		case IRQ_CORETMR:
 			set_irq_handler(irq, handle_simple_irq);
 			break;
@@ -1071,15 +1079,10 @@ int __init init_arch_irq(void)
 			set_irq_handler(irq, handle_level_irq);
 			break;
 #else /* !CONFIG_IPIPE */
-#ifdef CONFIG_TICKSOURCE_GPTMR0
-		case IRQ_TIMER0:
-			set_irq_handler(irq, handle_percpu_irq);
-			break;
-#endif /* CONFIG_TICKSOURCE_GPTMR0 */
 		default:
 			set_irq_handler(irq, handle_simple_irq);
 			break;
-#endif	/* !CONFIG_IPIPE */
+#endif /* !CONFIG_IPIPE */
 		}
 	}
 
-- 
1.6.4.2


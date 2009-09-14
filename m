Return-Path: <linux-kernel-owner+w=401wt.eu-S933497AbZINUI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbZINUI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbZINUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54013 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbZINUIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 11/72] Blackfin: allow EVT5 to preempt irqtail prologue (CONFIG_DEBUG_HWERR)
Date: Mon, 14 Sep 2009 16:07:15 -0400
Message-Id: <1252958896-25150-12-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/interrupt.S |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index ae7fc88..29fbf67 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -276,7 +276,15 @@ ENTRY(___ipipe_call_irqtail)
 	( r7:4, p5:3 ) = [sp++];
 	rets = [sp++];
 
-	r0 = 0x401f (z);
+#ifdef CONFIG_DEBUG_HWERR
+	/* enable irq14 & hwerr interrupt, until we transition to _evt_evt14 */
+	r0 = (EVT_IVG14 | EVT_IVHW | \
+		EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
+#else
+	/* Only enable irq14 interrupt, until we transition to _evt_evt14 */
+	r0 = (EVT_IVG14 | \
+		EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
+#endif
 	sti r0;
 	raise 14;		/* Branches to _evt_evt14 */
 2:
-- 
1.6.4.2


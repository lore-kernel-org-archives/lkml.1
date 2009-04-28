Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZD1EV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZD1EV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZD1EVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:21:46 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42614 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbZD1EVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:21:45 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/2] powerpc: share .data output section definition between 32 and 64 bits.
Date: Tue, 28 Apr 2009 00:21:41 -0400
Message-Id: <1240892502-9857-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <alpine.DEB.1.10.0904280015040.15450@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0904280015040.15450@vinegar-pot.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since upcoming changes will add several more common pieces of code
between the 32-bit and 64-bit powerpc architectures, it seems best to
unify these two blocks.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 433ae11..4f0f7d1 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -220,20 +220,19 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	_sdata = .;
 
-#ifdef CONFIG_PPC32
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		DATA_DATA
+#ifdef CONFIG_PPC32
 		*(.sdata)
 		*(.got.plt) *(.got)
-	}
 #else
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {
-		DATA_DATA
 		*(.data.rel*)
 		*(.toc1)
 		*(.branch_lt)
+#endif
 	}
 
+#ifndef CONFIG_PPC32
 	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
 		*(.opd)
 	}
-- 
1.6.2.1


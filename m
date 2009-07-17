Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbZGQAG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbZGQAG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933706AbZGQAGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39146 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933726AbZGQAGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:06:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 21/21] Blackfin: define HARDIRQ_BITS again for now
Date: Thu, 16 Jul 2009 20:05:46 -0400
Message-Id: <1247789146-18786-22-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default values of HARDIRQ_BITS and PREEMPT_BITS in common code leads to
build failure:

In file included from include/linux/interrupt.h:12,
                from include/linux/kernel_stat.h:8,
                from arch/blackfin/kernel/asm-offsets.c:32:
include/linux/hardirq.h:66:2: error: #error PREEMPT_ACTIVE is too low!

So until that gets resolved, just declare our own default value again.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/hardirq.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/hardirq.h b/arch/blackfin/include/asm/hardirq.h
index cbd52f8..0b78b87 100644
--- a/arch/blackfin/include/asm/hardirq.h
+++ b/arch/blackfin/include/asm/hardirq.h
@@ -6,6 +6,9 @@
 extern void ack_bad_irq(unsigned int irq);
 #define ack_bad_irq ack_bad_irq
 
+/* Define until common code gets sane defaults */
+#define HARDIRQ_BITS 9
+
 #include <asm-generic/hardirq.h>
 
 #endif
-- 
1.6.3.3


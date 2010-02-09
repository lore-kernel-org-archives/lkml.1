Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0BITeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:34:06 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40013 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0BITdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 24/35] move round_up/down to kernel.h
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to early_res moving up

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/proto.h |   10 ----------
 include/linux/kernel.h       |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 4009f65..6f414ed 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -23,14 +23,4 @@ extern int reboot_force;
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
-/*
- * This looks more complex than it should be. But we need to
- * get the type for the ~ right in round_down (it needs to be
- * as wide as the result!), and we want to evaluate the macro
- * arguments just once each.
- */
-#define __round_mask(x,y) ((__typeof__(x))((y)-1))
-#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
-#define round_down(x,y) ((x) & ~__round_mask(x,y))
-
 #endif /* _ASM_X86_PROTO_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 1221d23..8a6e583 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -44,6 +44,16 @@ extern const char linux_proc_banner[];
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+/*
+ * This looks more complex than it should be. But we need to
+ * get the type for the ~ right in round_down (it needs to be
+ * as wide as the result!), and we want to evaluate the macro
+ * arguments just once each.
+ */
+#define __round_mask(x,y) ((__typeof__(x))((y)-1))
+#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
+#define round_down(x,y) ((x) & ~__round_mask(x,y))
+
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
-- 
1.6.4.2


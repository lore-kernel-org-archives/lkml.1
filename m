Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab0APDNL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926Ab0APDNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:13:00 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33943 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833Ab0APDIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:06:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 22/37] move round_up/down to kernel.h
In-reply-to: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263611228-6751-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
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
index 785d7d1..9e1e9ef 100644
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


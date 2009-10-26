Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZJZPPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZJZPPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZJZPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:15:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:4631 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZJZPPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ONJrbruNbLpgMsyC62B1gs5uGdaa1XZZ1FugsXVBr01M7Dpe7tkjQv2hIGoSkewut/
         mg/pJi4lfL4V3lwkpOWPw1KtoQkksPILwTYbSlXq/jqXE0MTvdXdNdpTYADHmXMJHTgb
         eIiUjl5TdWs5ULNJ6I3dQpjUaFDbEu/DjpSFY=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: [PATCH -v6 09/13] tracing: Add __arch_notrace for arch specific requirement
Date: Mon, 26 Oct 2009 23:13:26 +0800
Message-Id: <07e35715c3af78e3c4b537940277240ed031365a.1256569489.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
 <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
 <3f47087b70a965fd679b17a59521671296457df1.1256569489.git.wuzhangjin@gmail.com>
 <f290e125634d164ec65b09b24b269815f78455ab.1256569489.git.wuzhangjin@gmail.com>
 <07dc907ec62353b1aca99b2850d3b2e4b734189a.1256569489.git.wuzhangjin@gmail.com>
 <374da7039d2e1b97083edd8bcd7811356884d427.1256569489.git.wuzhangjin@gmail.com>
 <3c82af564d70be05b92687949ed134ce034bf8db.1256569489.git.wuzhangjin@gmail.com>
 <a11775df0ec9665fab5861f4fa63a3e192b9ffec.1256569489.git.wuzhangjin@gmail.com>
 <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1256569489.git.wuzhangjin@gmail.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some arch need to not trace the common functions, but the other archs do
not need it, so, we add a new __arch_notrace to solve this problem, if
your arch need it, define it in your arch specific ftrace.h, otherwise,
ignore it! and if you just need to enable it with function graph tracer,
wrap it with "#ifdef CONFIG_FUNCTION_GRAPH_TRACER ... #endif".

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 include/linux/ftrace.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b4f97d..b3bd349 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -511,4 +511,23 @@ static inline void trace_hw_branch_oops(void) {}
 
 #endif /* CONFIG_HW_BRANCH_TRACER */
 
+/* Arch Specific notrace
+ *
+ * If your arch need it, define it in the arch specific ftrace.h
+ *
+ *	#define __arch_notrace
+ *
+ * If only need it with function graph tracer, wrap it.
+ *
+ *	#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ *	#define __arch_notrace
+ *	#endif
+ */
+#ifndef __arch_notrace
+#define __arch_notrace
+#else
+#undef __arch_notrace
+#define __arch_notrace	notrace
+#endif
+
 #endif /* _LINUX_FTRACE_H */
-- 
1.6.2.1


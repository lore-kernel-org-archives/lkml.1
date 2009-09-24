Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZIXPd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZIXPd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIXPd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:33:56 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:37176 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZIXPdz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:33:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAEcuu0pMROOX/2dsb2JhbACBUtV1hBsF
Date: Thu, 24 Sep 2009 11:33:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10.1/12] Immediate values fixes for modules
Message-ID: <20090924153353.GA29580@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133400.512675657@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090924133400.512675657@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:32:06 up 37 days,  2:21,  3 users,  load average: 0.31, 0.34,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation fixes for immediate values when modules are disabled.

Mathieu : merged two fixes.

From: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/immediate.h |    1 -
 include/linux/module.h    |   12 +++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

Index: linux.trees.git/include/linux/immediate.h
===================================================================
--- linux.trees.git.orig/include/linux/immediate.h	2009-09-24 09:20:37.000000000 -0400
+++ linux.trees.git/include/linux/immediate.h	2009-09-24 10:53:51.000000000 -0400
@@ -75,7 +75,6 @@ extern void imv_unref(struct __imv *begi
 #define imv_set(name, i)		(name##__imv = (i))
 
 static inline void core_imv_update(void) { }
-static inline void module_imv_update(void) { }
 static inline void imv_unref_core_init(void) { }
 
 #endif
Index: linux.trees.git/include/linux/module.h
===================================================================
--- linux.trees.git.orig/include/linux/module.h	2009-09-24 09:20:37.000000000 -0400
+++ linux.trees.git/include/linux/module.h	2009-09-24 10:53:51.000000000 -0400
@@ -538,9 +538,6 @@ extern void print_modules(void);
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
 
-extern void _module_imv_update(void);
-extern void module_imv_update(void);
-
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -661,6 +658,12 @@ static inline int module_get_iter_tracep
 	return 0;
 }
 
+#endif /* CONFIG_MODULES */
+
+#if defined(CONFIG_MODULES) && defined(CONFIG_IMMEDIATE)
+extern void _module_imv_update(void);
+extern void module_imv_update(void);
+#else
 static inline void _module_imv_update(void)
 {
 }
@@ -668,8 +671,7 @@ static inline void _module_imv_update(vo
 static inline void module_imv_update(void)
 {
 }
-
-#endif /* CONFIG_MODULES */
+#endif
 
 struct device_driver;
 #ifdef CONFIG_SYSFS

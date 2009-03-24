Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZCXKRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZCXKRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZCXKRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:17:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54452 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbZCXKRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:17:41 -0400
Subject: [PATCH] kmemtrace: fix build when CONFIG_KMEMTRACE is disabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 12:17:38 +0200
Message-Id: <1237889858.25315.75.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix build

This patch fixes the following allnoconfig failure:

  init/built-in.o: In function `start_kernel':
  (.init.text+0x669): undefined reference to `kmemtrace_init'

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/trace/kmemtrace.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
index 7514476..28ee69f 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmemtrace.h
@@ -12,7 +12,13 @@
 #include <linux/tracepoint.h>
 #include <linux/types.h>
 
+#ifdef CONFIG_KMEMTRACE
 extern void kmemtrace_init(void);
+#else
+static inline void kmemtrace_init(void)
+{
+}
+#endif
 
 DECLARE_TRACE(kmalloc,
 	      TP_PROTO(unsigned long call_site,
-- 
1.5.4.3




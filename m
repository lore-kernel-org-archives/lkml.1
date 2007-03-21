Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbXCUGyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbXCUGyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbXCUGyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:54:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:18806 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbXCUGyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:54:10 -0400
Message-ID: <d4cf37a60703202354l648e08fauecb730c2de46fd41@mail.gmail.com>
Date: Tue, 20 Mar 2007 23:54:10 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Add trec_snapshot and trec_print_snapshot in panic()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wink Saville <wink@saville.com>
---
 kernel/panic.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 623d182..64a047e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -20,6 +20,10 @@
 #include <linux/kexec.h>
 #include <linux/debug_locks.h>

+#ifdef CONFIG_TREC
+#include <linux/trec.h>
+#endif
+
 int panic_on_oops;
 int tainted;
 static int pause_on_oops;
@@ -66,6 +70,10 @@ NORET_TYPE void panic(const char * fmt, ...)
         unsigned long caller = (unsigned long) __builtin_return_address(0);
 #endif

+#ifdef CONFIG_TREC
+	trec_snapshot();
+#endif
+
 	/*
 	 * It's possible to come here directly from a panic-assertion and not
 	 * have preempt disabled. Some functions called from here want
@@ -96,6 +104,10 @@ NORET_TYPE void panic(const char * fmt, ...)
 	smp_send_stop();
 #endif

+#ifdef CONFIG_TREC
+	trec_print_snapshot();
+#endif
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);

 	if (!panic_blink)
-- 
1.5.0.rc2

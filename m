Return-Path: <linux-kernel-owner+w=401wt.eu-S1750801AbXBMOXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750801AbXBMOXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbXBMOXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:23:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbXBMOXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:23:07 -0500
Date: Tue, 13 Feb 2007 15:20:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 01/11] syslets: add async.h include file, kernel-side API definitions
Message-ID: <20070213142019.GB638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060529212109.GA2058@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add include/linux/async.h which contains the kernel-side API
declarations.

it also provides NOP stubs for the !CONFIG_ASYNC_SUPPORT case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: linux/include/linux/async.h
===================================================================
--- /dev/null
+++ linux/include/linux/async.h
@@ -0,0 +1,25 @@
+#ifndef _LINUX_ASYNC_H
+#define _LINUX_ASYNC_H
+/*
+ * The syslet subsystem - asynchronous syscall execution support.
+ *
+ * Generic kernel API definitions:
+ */
+
+#ifdef CONFIG_ASYNC_SUPPORT
+extern void async_init(struct task_struct *t);
+extern void async_exit(struct task_struct *t);
+extern void __async_schedule(struct task_struct *t);
+#else /* !CONFIG_ASYNC_SUPPORT */
+static inline void async_init(struct task_struct *t)
+{
+}
+static inline void async_exit(struct task_struct *t)
+{
+}
+static inline void __async_schedule(struct task_struct *t)
+{
+}
+#endif /* !CONFIG_ASYNC_SUPPORT */
+
+#endif

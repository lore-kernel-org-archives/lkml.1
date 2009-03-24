Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbZCXMEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbZCXMEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZCXMEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:04:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:54168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZCXMEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:04:37 -0400
Date: Tue, 24 Mar 2009 12:03:36 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237889858.25315.75.camel@penberg-laptop>
References: <1237889858.25315.75.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] kmemtrace: fix build when CONFIG_KMEMTRACE is disabled
Message-ID: <tip-ebe7ac8e115e6b6e1f4c2a177ba718f43b6bd23e@git.kernel.org>
Git-Commit-ID: ebe7ac8e115e6b6e1f4c2a177ba718f43b6bd23e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 12:03:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebe7ac8e115e6b6e1f4c2a177ba718f43b6bd23e
Gitweb:     http://git.kernel.org/tip/ebe7ac8e115e6b6e1f4c2a177ba718f43b6bd23e
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 24 Mar 2009 12:17:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 11:31:51 +0100

kmemtrace: fix build when CONFIG_KMEMTRACE is disabled

Impact: fix build

This patch fixes the following allnoconfig failure:

  init/built-in.o: In function `start_kernel':
  (.init.text+0x669): undefined reference to `kmemtrace_init'

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1237889858.25315.75.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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

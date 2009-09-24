Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZIXXSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZIXXSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZIXXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:18:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZIXXSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:18:10 -0400
Date: Thu, 24 Sep 2009 19:17:48 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com
Message-Id: <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com>
In-Reply-To: <cover.1253831945.git.jbaron@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com>
Subject: [PATCH 1/4] jump label - make init_kernel_text() global
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


allow usage of init_kernel_text - we need this in jump labeling to avoid
attemtpting to patch code that has been freed as in the __init sections


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/kernel.h |    1 +
 kernel/extable.c       |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f61039e..9d3419f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -295,6 +295,7 @@ extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
 
+extern int init_kernel_text(unsigned long addr);
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
diff --git a/kernel/extable.c b/kernel/extable.c
index 7f8f263..f6893ad 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -52,7 +52,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 	return e;
 }
 
-static inline int init_kernel_text(unsigned long addr)
+int init_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_sinittext &&
 	    addr <= (unsigned long)_einittext)
-- 
1.6.2.5


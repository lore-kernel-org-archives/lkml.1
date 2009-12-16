Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbZLPIJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbZLPIJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761751AbZLPIJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:09:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1200 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761739AbZLPIJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:15 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] kernel.h: Add argument names to strtoXX, Xscanf prototypes
Date: Wed, 16 Dec 2009 00:09:03 -0800
Message-Id: <74e9c2bee515cb0e6a9825f108a27a55489a7793.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's easier to parse prototypes with argument names.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9206268..75e7439 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -137,18 +137,30 @@ NORET_TYPE void panic(const char *fmt, ...)
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-NORET_TYPE void do_exit(long error_code)
+NORET_TYPE void do_exit(long code)
 	ATTRIB_NORET;
-NORET_TYPE void complete_and_exit(struct completion *, long)
+NORET_TYPE void complete_and_exit(struct completion *comp, long code)
 	ATTRIB_NORET;
-extern unsigned long simple_strtoul(const char *, char **, unsigned int);
-extern long simple_strtol(const char *, char **, unsigned int);
-extern unsigned long long simple_strtoull(const char *, char **, unsigned int);
-extern long long simple_strtoll(const char *, char **, unsigned int);
-extern int strict_strtoul(const char *, unsigned int, unsigned long *);
-extern int strict_strtol(const char *, unsigned int, long *);
-extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
-extern int strict_strtoll(const char *, unsigned int, long long *);
+
+/*
+ * stdlib - String to type conversions
+ */
+extern unsigned long simple_strtoul(const char *cp, char **endp,
+				    unsigned int base);
+extern long simple_strtol(const char *cp, char **endp, unsigned int base);
+extern unsigned long long simple_strtoull(const char *cp, char **endp,
+					  unsigned int base);
+extern long long simple_strtoll(const char *cp, char **endp, unsigned int base);
+extern int strict_strtoul(const char *cp, unsigned int base,
+			  unsigned long *res);
+extern int strict_strtol(const char *cp, unsigned int base, long *res);
+extern int strict_strtoull(const char *cp, unsigned int base,
+			   unsigned long long *res);
+extern int strict_strtoll(const char *cp, unsigned int base, long long *res);
+
+/*
+ * string - String handling
+ */
 extern int sprintf(char *buf, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
@@ -165,9 +177,9 @@ extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
-extern int sscanf(const char *, const char *, ...)
+extern int sscanf(const char *buf, const char *fmt, ...)
 	__attribute__ ((format (scanf, 2, 3)));
-extern int vsscanf(const char *, const char *, va_list)
+extern int vsscanf(const char *buf, const char *fmt, va_list)
 	__attribute__ ((format (scanf, 2, 0)));
 
 extern int get_option(char **str, int *pint);
-- 
1.6.6.rc0.57.gad7a


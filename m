Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab0BYPyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:54:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35392 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab0BYPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:54:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rZtQ3ayspTnibXdGD+SUAmivTV+FNe7QgQ0HyH4LX34qUhnCoY+RKK4MVc5VIVpeIH
         DkHnsruwhBxqMnjUqRfH8uoG/CLtYUKGpiRXff8Dd8eQy56FSsIsHogUjkZijxu5lYQT
         +PWqBaOZGPXPkUEQYRMwyylFzRiqTlXBjCEOg=
Date: Thu, 25 Feb 2010 23:53:59 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/07] kernel.h string cleanup
Message-ID: <20100225155359.GA2722@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup kernel.h string related stuff, move to linux/string.h

Due to lots of files need them, include string.h in kernel.h just
for convinience. It can be thought as the first step of further cleanup. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/kernel.h |   29 +----------------------------
 include/linux/string.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 28 deletions(-)

--- linux-2.6.orig/include/linux/kernel.h	2010-02-25 20:45:26.000000000 +0800
+++ linux-2.6/include/linux/kernel.h	2010-02-25 20:46:11.000000000 +0800
@@ -15,6 +15,7 @@
 #include <linux/typecheck.h>
 #include <linux/printk.h>
 #include <linux/panic.h>
+#include <linux/string.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -136,34 +137,6 @@ NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
-extern unsigned long simple_strtoul(const char *,char **,unsigned int);
-extern long simple_strtol(const char *,char **,unsigned int);
-extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
-extern long long simple_strtoll(const char *,char **,unsigned int);
-extern int strict_strtoul(const char *, unsigned int, unsigned long *);
-extern int strict_strtol(const char *, unsigned int, long *);
-extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
-extern int strict_strtoll(const char *, unsigned int, long long *);
-extern int sprintf(char * buf, const char * fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int vsprintf(char *buf, const char *, va_list)
-	__attribute__ ((format (printf, 2, 0)));
-extern int snprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
-
-extern int sscanf(const char *, const char *, ...)
-	__attribute__ ((format (scanf, 2, 3)));
-extern int vsscanf(const char *, const char *, va_list)
-	__attribute__ ((format (scanf, 2, 0)));
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
--- linux-2.6.orig/include/linux/string.h	2010-02-25 20:43:06.000000000 +0800
+++ linux-2.6/include/linux/string.h	2010-02-25 20:49:16.000000000 +0800
@@ -142,5 +142,35 @@ static inline bool strstarts(const char 
 {
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
+
+extern unsigned long simple_strtoul(const char *, char **, unsigned int);
+extern long simple_strtol(const char *, char **, unsigned int);
+extern unsigned long long simple_strtoull(const char *, char **, unsigned int);
+extern long long simple_strtoll(const char *, char **, unsigned int);
+extern int strict_strtoul(const char *, unsigned int, unsigned long *);
+extern int strict_strtol(const char *, unsigned int, long *);
+extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
+extern int strict_strtoll(const char *, unsigned int, long long *);
+extern int sprintf(char *buf, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int vsprintf(char *buf, const char *, va_list)
+	__attribute__ ((format (printf, 2, 0)));
+extern int snprintf(char *buf, size_t size, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 3, 0)));
+extern int scnprintf(char *buf, size_t size, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 3, 0)));
+extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
+
+extern int sscanf(const char *, const char *, ...)
+	__attribute__ ((format (scanf, 2, 3)));
+extern int vsscanf(const char *, const char *, va_list)
+	__attribute__ ((format (scanf, 2, 0)));
 #endif
+
 #endif /* _LINUX_STRING_H_ */

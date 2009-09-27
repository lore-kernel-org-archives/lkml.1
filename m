Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZI0SZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZI0SZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZI0SZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:25:25 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:48059 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZI0SZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:25:24 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>,
       Cesar Eduardo Barros <cesarb@cesarb.net>,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH] WARN_ONCE(): use bool for condition
Date: Sun, 27 Sep 2009 15:25:12 -0300
Message-Id: <1254075912-17557-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <4ABFAB27.1040608@cesarb.net>
References: <4ABFAB27.1040608@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the type bool for __ret_warn_once and __ret_warn_on, instead of int
with a double negation. This matches the intent of the code better and
should allow the compiler to generate better code, like in commit
70867453092297be9afb2249e712a1f960ec0a09. However, some versions of gcc
seems to pessimize the code instead when the condition is not trivial.

Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 arch/avr32/include/asm/bug.h    |    2 +-
 arch/blackfin/include/asm/bug.h |    2 +-
 arch/parisc/include/asm/bug.h   |    2 +-
 arch/powerpc/include/asm/bug.h  |    2 +-
 arch/s390/include/asm/bug.h     |    2 +-
 arch/sh/include/asm/bug.h       |    4 ++--
 include/asm-generic/bug.h       |   12 ++++++------
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/avr32/include/asm/bug.h b/arch/avr32/include/asm/bug.h
index 331d45b..c636fec 100644
--- a/arch/avr32/include/asm/bug.h
+++ b/arch/avr32/include/asm/bug.h
@@ -57,7 +57,7 @@
 
 #define WARN_ON(condition)							\
 	({								\
-		int __ret_warn_on = !!(condition);			\
+		bool __ret_warn_on = (condition);			\
 		if (unlikely(__ret_warn_on))				\
 			_BUG_OR_WARN(BUGFLAG_WARNING);			\
 		unlikely(__ret_warn_on);				\
diff --git a/arch/blackfin/include/asm/bug.h b/arch/blackfin/include/asm/bug.h
index 655e495..3584d52 100644
--- a/arch/blackfin/include/asm/bug.h
+++ b/arch/blackfin/include/asm/bug.h
@@ -46,7 +46,7 @@
 
 #define WARN_ON(condition)							\
 	({								\
-		int __ret_warn_on = !!(condition);			\
+		bool __ret_warn_on = (condition);			\
 		if (unlikely(__ret_warn_on))				\
 			_BUG_OR_WARN(BUGFLAG_WARNING);			\
 		unlikely(__ret_warn_on);				\
diff --git a/arch/parisc/include/asm/bug.h b/arch/parisc/include/asm/bug.h
index 8cfc553..373e16a 100644
--- a/arch/parisc/include/asm/bug.h
+++ b/arch/parisc/include/asm/bug.h
@@ -74,7 +74,7 @@
 
 
 #define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
+	bool __ret_warn_on = (x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.h
index 64e1fdc..eda46ac 100644
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -95,7 +95,7 @@
 } while (0)
 
 #define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
+	bool __ret_warn_on = (x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
diff --git a/arch/s390/include/asm/bug.h b/arch/s390/include/asm/bug.h
index 7efd0ab..577b6d1 100644
--- a/arch/s390/include/asm/bug.h
+++ b/arch/s390/include/asm/bug.h
@@ -53,7 +53,7 @@
 } while (0)
 
 #define WARN_ON(x) ({					\
-	int __ret_warn_on = !!(x);			\
+	bool __ret_warn_on = (x);			\
 	if (__builtin_constant_p(__ret_warn_on)) {	\
 		if (__ret_warn_on)			\
 			__EMIT_BUG(BUGFLAG_WARNING);	\
diff --git a/arch/sh/include/asm/bug.h b/arch/sh/include/asm/bug.h
index d02c01b..7a7872c 100644
--- a/arch/sh/include/asm/bug.h
+++ b/arch/sh/include/asm/bug.h
@@ -62,7 +62,7 @@ do {							\
 } while (0)
 
 #define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
+	bool __ret_warn_on = (x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
@@ -87,7 +87,7 @@ do {							\
 } while (0)
 
 #define UNWINDER_BUG_ON(x) ({					\
-	int __ret_unwinder_on = !!(x);				\
+	bool __ret_unwinder_on = (x);				\
 	if (__builtin_constant_p(__ret_unwinder_on)) {		\
 		if (__ret_unwinder_on)				\
 			UNWINDER_BUG();				\
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 18c435d..9eb001e 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -71,7 +71,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #ifndef WARN_ON
 #define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	if (unlikely(__ret_warn_on))					\
 		__WARN();						\
 	unlikely(__ret_warn_on);					\
@@ -80,7 +80,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #ifndef WARN
 #define WARN(condition, format...) ({						\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	if (unlikely(__ret_warn_on))					\
 		__WARN_printf(format);					\
 	unlikely(__ret_warn_on);					\
@@ -98,14 +98,14 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	unlikely(__ret_warn_on);					\
 })
 #endif
 
 #ifndef WARN
 #define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	unlikely(__ret_warn_on);					\
 })
 #endif
@@ -114,7 +114,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #define WARN_ON_ONCE(condition)	({				\
 	static bool __warned;					\
-	int __ret_warn_once = !!(condition);			\
+	bool __ret_warn_once = (condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN_ON(!__warned)) 			\
@@ -124,7 +124,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #define WARN_ONCE(condition, format...)	({			\
 	static bool __warned;					\
-	int __ret_warn_once = !!(condition);			\
+	bool __ret_warn_once = (condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN(!__warned, format)) 			\
-- 
1.6.4.4


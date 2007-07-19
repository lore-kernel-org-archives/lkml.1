Return-Path: <linux-kernel-owner+w=401wt.eu-S1765508AbXGSVL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765508AbXGSVL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbXGSVLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:11:52 -0400
Received: from verein.lst.de ([213.95.11.210]:54432 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760124AbXGSVLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:11:51 -0400
Date: Thu, 19 Jul 2007 23:11:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kill DECLARE_MUTEX_LOCKED
Message-ID: <20070719211135.GA32725@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DECLARE_MUTEX_LOCKED was used for semaphores used as completions and
we've got rid of them.  Well, except for one in libusual that the
maintainer explicitly wants to keep as semaphore.  So convert that
useage to an explicit sema_init and kill of DECLARE_MUTEX_LOCKED so that
new code is reminded to use a completion.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/asm-alpha/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-alpha/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-alpha/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -30,7 +30,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-arm/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-arm/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-arm/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -28,7 +28,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INIT(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-arm26/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-arm26/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-arm26/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -29,7 +29,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INIT(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-avr32/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-avr32/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-avr32/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -36,7 +36,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-blackfin/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-blackfin/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-blackfin/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -35,7 +35,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-cris/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-cris/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-cris/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -35,7 +35,6 @@ struct semaphore {
         struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-frv/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-frv/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-frv/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -49,7 +49,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-h8300/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-h8300/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-h8300/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -39,7 +39,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-i386/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-i386/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-i386/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -59,7 +59,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-ia64/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-ia64/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -28,7 +28,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void
 sema_init (struct semaphore *sem, int val)
Index: linux-2.6/include/asm-m32r/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-m32r/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-m32r/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -35,7 +35,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-m68k/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-m68k/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-m68k/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -40,7 +40,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-m68knommu/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-m68knommu/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-m68knommu/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -39,7 +39,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-mips/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-mips/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-mips/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -49,7 +49,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-parisc/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-parisc/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-parisc/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -53,7 +53,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 extern inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-powerpc/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-powerpc/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -35,7 +35,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-s390/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-s390/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-s390/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -33,7 +33,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-sh/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-sh/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-sh/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -37,7 +37,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-sh64/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-sh64/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-sh64/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -44,7 +44,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-sparc/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-sparc/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-sparc/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -26,7 +26,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-sparc64/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-sparc64/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -26,7 +26,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC(name, 0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-v850/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-v850/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-v850/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -22,7 +22,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER (name,count)
 
 #define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC (name,1)
-#define DECLARE_MUTEX_LOCKED(name)	__DECLARE_SEMAPHORE_GENERIC (name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-x86_64/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-x86_64/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -60,7 +60,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/include/asm-xtensa/semaphore.h
===================================================================
--- linux-2.6.orig/include/asm-xtensa/semaphore.h	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/include/asm-xtensa/semaphore.h	2007-07-19 22:08:44.000000000 +0200
@@ -33,7 +33,6 @@ struct semaphore {
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
 static inline void sema_init (struct semaphore *sem, int val)
 {
Index: linux-2.6/drivers/usb/storage/libusual.c
===================================================================
--- linux-2.6.orig/drivers/usb/storage/libusual.c	2007-07-19 22:06:28.000000000 +0200
+++ linux-2.6/drivers/usb/storage/libusual.c	2007-07-19 22:08:44.000000000 +0200
@@ -30,7 +30,7 @@ static atomic_t usu_bias = ATOMIC_INIT(U
 #define BIAS_NAME_SIZE  (sizeof("usb-storage"))
 static const char *bias_names[3] = { "none", "usb-storage", "ub" };
 
-static DECLARE_MUTEX_LOCKED(usu_init_notify);
+static struct semaphore usu_init_notify;
 static DECLARE_COMPLETION(usu_end_notify);
 static atomic_t total_threads = ATOMIC_INIT(0);
 
@@ -204,6 +204,8 @@ static int __init usb_usual_init(void)
 {
 	int rc;
 
+	sema_init(&usu_init_notify, 0);
+
 	rc = usb_register(&usu_driver);
 	up(&usu_init_notify);
 	return rc;

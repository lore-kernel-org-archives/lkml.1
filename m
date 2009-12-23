Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZLWRYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZLWRYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZLWRYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:24:43 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:41774 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZLWRYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:24:42 -0500
Date: Wed, 23 Dec 2009 09:23:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] kfifo: fix Error/broken kernel-doc notation
Message-Id: <20091223092333.6d88b7a8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A0B0203.4B325224.02C3:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc errors and warnings in new header file kfifo.h.
Don't use kernel-doc "/**" for internal functions whose comments
are not in kernel-doc format.

kernel-doc section header names (like "Note:") must be unique
per function.  Looks like I need to document that.

Error(include/linux/kfifo.h:76): duplicate section name 'Note'
Warning(include/linux/kfifo.h:88): Excess function parameter 'size' description in 'INIT_KFIFO'
Error(include/linux/kfifo.h:101): duplicate section name 'Note'
Warning(include/linux/kfifo.h:257): No description found for parameter 'fifo'
  (many of this last type, from internal functions)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
---
 include/linux/kfifo.h |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- linux-2.6.33-rc1-git3.orig/include/linux/kfifo.h
+++ linux-2.6.33-rc1-git3/include/linux/kfifo.h
@@ -69,8 +69,8 @@ struct kfifo {
  * @name: name of the declared kfifo datatype
  * @size: size of the fifo buffer
  *
- * Note: the macro can be used inside struct or union declaration
- * Note: the macro creates two objects:
+ * Note1: the macro can be used inside struct or union declaration
+ * Note2: the macro creates two objects:
  *  A kfifo object with the given name and a buffer for the kfifo
  *  object named name##kfifo_buffer
  */
@@ -83,7 +83,6 @@ union { \
 /**
  * INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
  * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
  */
 #define INIT_KFIFO(name) \
 	name = __kfifo_initializer(sizeof(name##kfifo_buffer) - \
@@ -94,8 +93,8 @@ union { \
  * @name: name of the declared kfifo datatype
  * @size: size of the fifo buffer
  *
- * Note: the macro can be used for global and local kfifo data type variables
- * Note: the macro creates two objects:
+ * Note1: the macro can be used for global and local kfifo data type variables
+ * Note2: the macro creates two objects:
  *  A kfifo object with the given name and a buffer for the kfifo
  *  object named name##kfifo_buffer
  */
@@ -249,7 +248,7 @@ extern __must_check unsigned int kfifo_f
 extern __must_check unsigned int kfifo_to_user(struct kfifo *fifo,
 	void __user *to, unsigned int n);
 
-/**
+/*
  * __kfifo_add_out internal helper function for updating the out offset
  */
 static inline void __kfifo_add_out(struct kfifo *fifo,
@@ -259,7 +258,7 @@ static inline void __kfifo_add_out(struc
 	fifo->out += off;
 }
 
-/**
+/*
  * __kfifo_add_in internal helper function for updating the in offset
  */
 static inline void __kfifo_add_in(struct kfifo *fifo,
@@ -269,7 +268,7 @@ static inline void __kfifo_add_in(struct
 	fifo->in += off;
 }
 
-/**
+/*
  * __kfifo_off internal helper function for calculating the index of a
  * given offeset
  */
@@ -278,7 +277,7 @@ static inline unsigned int __kfifo_off(s
 	return off & (fifo->size - 1);
 }
 
-/**
+/*
  * __kfifo_peek_n internal helper function for determinate the length of
  * the next record in the fifo
  */
@@ -299,7 +298,7 @@ static inline unsigned int __kfifo_peek_
 #undef	__KFIFO_GET
 }
 
-/**
+/*
  * __kfifo_poke_n internal helper function for storing the length of
  * the next record into the fifo
  */
@@ -319,7 +318,7 @@ static inline void __kfifo_poke_n(struct
 #undef	__KFIFO_PUT
 }
 
-/**
+/*
  * __kfifo_in_... internal functions for put date into the fifo
  * do not call it directly, use kfifo_in_rec() instead
  */
@@ -367,7 +366,7 @@ static inline __must_check unsigned int 
 	return __kfifo_in_rec(fifo, from, n, recsize);
 }
 
-/**
+/*
  * __kfifo_out_... internal functions for get date from the fifo
  * do not call it directly, use kfifo_out_rec() instead
  */
@@ -425,7 +424,7 @@ static inline __must_check unsigned int 
 	return __kfifo_out_rec(fifo, to, n, recsize, total);
 }
 
-/**
+/*
  * __kfifo_from_user_... internal functions for transfer from user space into
  * the fifo. do not call it directly, use kfifo_from_user_rec() instead
  */
@@ -474,7 +473,7 @@ static inline __must_check unsigned int 
 	return __kfifo_from_user_rec(fifo, from, n, recsize);
 }
 
-/**
+/*
  * __kfifo_to_user_... internal functions for transfer fifo data into user space
  * do not call it directly, use kfifo_to_user_rec() instead
  */
@@ -533,7 +532,7 @@ static inline __must_check unsigned int 
 	return __kfifo_to_user_rec(fifo, to, n, recsize, total);
 }
 
-/**
+/*
  * __kfifo_peek_... internal functions for peek into the next fifo record
  * do not call it directly, use kfifo_peek_rec() instead
  */
@@ -557,7 +556,7 @@ static inline __must_check unsigned int 
 	return __kfifo_peek_n(fifo, recsize);
 }
 
-/**
+/*
  * __kfifo_skip_... internal functions for skip the next fifo record
  * do not call it directly, use kfifo_skip_rec() instead
  */

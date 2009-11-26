Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbZKZPyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbZKZPyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbZKZPyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:54:23 -0500
Received: from www84.your-server.de ([213.133.104.84]:52759 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbZKZPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:54:22 -0500
Subject: [PATCH] new kfifo API: undef temporary defines
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 Nov 2009 16:53:54 +0100
Message-ID: <1259250834.26705.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch undef temporary used defines after the last usage.

The patch-set is against kfifo API v.07, which is currently included in
the -mm tree

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 kfifo.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -u -N -r -p kfifo7/include/linux/kfifo.h kfifo8/include/linux/kfifo.h
--- kfifo7/include/linux/kfifo.h	2009-11-19 20:55:16.596339811 +0100
+++ kfifo8/include/linux/kfifo.h	2009-11-26 16:46:48.826439335 +0100
@@ -55,6 +55,7 @@ struct kfifo {
  * Macros for declaration and initialization of the kfifo datatype
  */
 
+/* helper macro */
 #define __kfifo_initializer(s, b) \
 	(struct kfifo) { \
 		.size	= s, \
@@ -102,6 +103,8 @@ union { \
 	unsigned char name##kfifo_buffer[size]; \
 	struct kfifo name = __kfifo_initializer(size, name##kfifo_buffer)
 
+#undef __kfifo_initializer
+
 extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
@@ -293,6 +296,7 @@ static inline unsigned int __kfifo_peek_
 		l |= __KFIFO_GET(fifo, 1, 8);
 
 	return l;
+#undef	__KFIFO_GET
 }
 
 /**
@@ -312,6 +316,7 @@ static inline void __kfifo_poke_n(struct
 
 	if (--recsize)
 		__KFIFO_PUT(fifo, 1, n, 8);
+#undef	__KFIFO_PUT
 }
 
 /**



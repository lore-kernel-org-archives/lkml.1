Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbZL0VDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbZL0VDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZL0VDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:03:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43514 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZL0VDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:03:18 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
In-Reply-To: <200912271003.631128760@firstfloor.org>
To: stefani@seibold.net, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [6/6] kfifo: Document everywhere that size has to be power of two
Message-Id: <20091227210316.B116EB17C3@basil.firstfloor.org>
Date: Sun, 27 Dec 2009 22:03:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On my first try using them I missed that the fifos need to 
be power of two, resulting in a runtime bug. Document that requirement
everywhere (and fix one grammar bug)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kfifo.h |    4 ++--
 kernel/kfifo.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/include/linux/kfifo.h
===================================================================
--- linux.orig/include/linux/kfifo.h
+++ linux/include/linux/kfifo.h
@@ -67,7 +67,7 @@ struct kfifo {
 /**
  * DECLARE_KFIFO - macro to declare a kfifo and the associated buffer
  * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
+ * @size: size of the fifo buffer. Must be a power of two.
  *
  * Note1: the macro can be used inside struct or union declaration
  * Note2: the macro creates two objects:
@@ -91,7 +91,7 @@ union { \
 /**
  * DEFINE_KFIFO - macro to define and initialize a kfifo
  * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
+ * @size: size of the fifo buffer. Must be a power of two.
  *
  * Note1: the macro can be used for global and local kfifo data type variables
  * Note2: the macro creates two objects:
Index: linux/kernel/kfifo.c
===================================================================
--- linux.orig/kernel/kfifo.c
+++ linux/kernel/kfifo.c
@@ -41,7 +41,7 @@ static void _kfifo_init(struct kfifo *fi
  * kfifo_init - initialize a FIFO using a preallocated buffer
  * @fifo: the fifo to assign the buffer
  * @buffer: the preallocated buffer to be used.
- * @size: the size of the internal buffer, this have to be a power of 2.
+ * @size: the size of the internal buffer, this has to be a power of 2.
  *
  */
 void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size)

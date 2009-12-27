Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZL0VE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZL0VE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZL0VE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:04:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZL0VDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:03:17 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
In-Reply-To: <200912271003.631128760@firstfloor.org>
To: stefani@seibold.net, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [5/6] kfifo: Add kfifo_initialized
Message-Id: <20091227210315.AE55EB17C3@basil.firstfloor.org>
Date: Sun, 27 Dec 2009 22:03:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Simple inline that checks if kfifo_init() has been executed
on a fifo.

This is useful for walking all per CPU fifos, when some of them
might not have been brought up yet.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kfifo.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/include/linux/kfifo.h
===================================================================
--- linux.orig/include/linux/kfifo.h
+++ linux/include/linux/kfifo.h
@@ -117,6 +117,16 @@ extern __must_check unsigned int kfifo_o
 extern __must_check unsigned int kfifo_out_peek(struct kfifo *fifo,
 				void *to, unsigned int len, unsigned offset);
 
+/**
+ * kfifo_initialized - Check if kfifo is initialized.
+ * @fifo: fifo to check
+ * Return %true if FIFO is initialized, otherwise %false.
+ * Assumes the fifo was 0 before.
+ */
+static inline bool kfifo_initialized(struct kfifo *fifo)
+{
+	return fifo->buffer != 0;
+}
 
 /**
  * kfifo_reset - removes the entire FIFO contents

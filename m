Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbZHNUC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbZHNUC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932746AbZHNUC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:02:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15801 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbZHNUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:02:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABBghUqrR7O6/2dsb2JhbAC6TYgtkQcFhBk
X-IronPort-AV: E=Sophos;i="4.43,381,1246838400"; 
   d="scan'208";a="367504387"
Date: Fri, 14 Aug 2009 13:02:54 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Add "const" attribute to kfifo input buffer pointers
Message-ID: <20090814200254.GA26288@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the input buffer arguments for kfifo_put() and __kfifo_put() to have
the "const" attribute.

Signed-off-by: David VomLehn
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 29f62e1..38d4578 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -38,7 +38,7 @@ extern struct kfifo *kfifo_alloc(unsigned int size, gfp_t gfp_mask,
 				 spinlock_t *lock);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int __kfifo_put(struct kfifo *fifo,
-				unsigned char *buffer, unsigned int len);
+				const unsigned char *buffer, unsigned int len);
 extern unsigned int __kfifo_get(struct kfifo *fifo,
 				unsigned char *buffer, unsigned int len);
 
@@ -77,7 +77,8 @@ static inline void kfifo_reset(struct kfifo *fifo)
  * bytes copied.
  */
 static inline unsigned int kfifo_put(struct kfifo *fifo,
-				     unsigned char *buffer, unsigned int len)
+				     const unsigned char *buffer,
+				     unsigned int len)
 {
 	unsigned long flags;
 	unsigned int ret;
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 26539e3..1082952 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(kfifo_free);
  * writer, you don't need extra locking to use these functions.
  */
 unsigned int __kfifo_put(struct kfifo *fifo,
-			 unsigned char *buffer, unsigned int len)
+			 const unsigned char *buffer, unsigned int len)
 {
 	unsigned int l;
 

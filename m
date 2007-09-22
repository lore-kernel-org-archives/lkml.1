Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXIVIl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXIVIl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 04:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXIVIlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 04:41:20 -0400
Received: from web52001.mail.re2.yahoo.com ([206.190.49.248]:21689 "HELO
	web52001.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751057AbXIVIlS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 04:41:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=MSdYe8fE3z7U+kSjAnKqTiq4i+RGq0f1FXJKhlnB2oycKvyMnDCN5c09cGBepm9GpO/sEh8G35CEE9WGHF6nFVk5c0uTUb8l1IC0w41STnY8VzvpEKNINyuaRoBNMzC0m/hCm85uf1RI2Cdu5W7Ie/jLVdP/yLT1gj5SkuWKK4o=;
X-YMail-OSG: hIVUc7IVM1lMhdAj.xV9wu3XJlf7ToT2nsLznTjbGLoZz1jq9AR4asFac8cGixp4WW8ylWnZ4UKKX4HZdy6dJFvWXGTb5kwLdTFLLo9jy_UQJQMrMrD0sVNtWbsCgA--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Sat, 22 Sep 2007 01:41:17 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [PATCH] include/linux/mutex.h: unclear reference to convention
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <664979.77080.qm@web52001.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Reference to two different conventions is unnecessarily unclear unless you know them already and requires seeking and reading another file for understanding.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
---

--- linux-2.6.23-rc7/include/linux/mutex.h    2007-09-22 11:09:42.223763000 +0300
+++ linux-2.6.23/include/linux/mutex.h    2007-09-22 11:11:19.416761000 +0300
@@ -132,9 +132,19 @@ extern int __must_check mutex_lock_inter
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 #endif
 
-/*
- * NOTE: mutex_trylock() follows the spin_trylock() convention,
- *       not the down_trylock() convention!
+/***
+ * mutex_trylock - try acquire the mutex, without waiting
+ * @lock: the mutex to be acquired
+ *
+ * Try to acquire the mutex atomically. Returns 1 if the mutex
+ * has been acquired successfully, and 0 on contention.
+ *
+ * NOTE: this function follows the spin_trylock() convention, so
+ * it is negated to the down_trylock() return values! Be careful
+ * about this when converting semaphore users to mutexes.
+ *
+ * This function must not be used in interrupt context. The
+ * mutex must be released by the same task that acquired it.
  */
 extern int fastcall mutex_trylock(struct mutex *lock);
 extern void fastcall mutex_unlock(struct mutex *lock);





      ________ 
Yahoo! Clever: Stellen Sie Fragen und finden Sie Antworten. Teilen Sie Ihr Wissen. www.yahoo.de/clever


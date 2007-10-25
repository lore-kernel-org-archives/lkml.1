Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbXJYVWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbXJYVWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXJYVV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:21:56 -0400
Received: from xenotime.net ([66.160.160.81]:47140 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752351AbXJYVV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:21:56 -0400
Date: Thu, 25 Oct 2007 14:21:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, nickpiggin@yahoo.com.au, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH v3] bitops kernel-doc: inline instead of macro
Message-Id: <20071025142149.6610f5ef.rdunlap@xenotime.net>
In-Reply-To: <20071025134814.caced2e3.akpm@linux-foundation.org>
References: <20071023220959.a359d57d.rdunlap@xenotime.net>
	<200710241800.19764.nickpiggin@yahoo.com.au>
	<20071025093159.3ea69d03.rdunlap@xenotime.net>
	<alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain>
	<20071025095540.827d4333.rdunlap@xenotime.net>
	<20071025134814.caced2e3.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We might as well clean stuff up as we're churning the code.
> 
> 
> Andy, I thought we were going to whine about __inline__ and __inline, too?

Thomas, can you replace the previous patch with this one?

Usage of __inline__ is fixed in the next patch (after this one).

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Use duplicated inline functions for test_and_set_bit_lock() on x86
instead of #define macros, thus avoiding a bad example.  This allows
kernel-doc to run cleanly instead of terminating with an error:

Error(linux-2.6.24-rc1//include/asm-x86/bitops_32.h:188): cannot understand prototype: 'test_and_set_bit_lock test_and_set_bit '

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-x86/bitops_32.h |    7 +++++--
 include/asm-x86/bitops_64.h |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

--- linux-2.6.24-rc1.orig/include/asm-x86/bitops_32.h
+++ linux-2.6.24-rc1/include/asm-x86/bitops_32.h
@@ -183,9 +183,12 @@ static inline int test_and_set_bit(int n
  * @nr: Bit to set
  * @addr: Address to count from
  *
- * This is the same as test_and_set_bit on x86
+ * This is the same as test_and_set_bit on x86.
  */
-#define test_and_set_bit_lock test_and_set_bit
+static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+{
+	return test_and_set_bit(nr, addr);
+}
 
 /**
  * __test_and_set_bit - Set a bit and return its old value
--- linux-2.6.24-rc1.orig/include/asm-x86/bitops_64.h
+++ linux-2.6.24-rc1/include/asm-x86/bitops_64.h
@@ -173,9 +173,12 @@ static __inline__ int test_and_set_bit(i
  * @nr: Bit to set
  * @addr: Address to count from
  *
- * This is the same as test_and_set_bit on x86
+ * This is the same as test_and_set_bit on x86.
  */
-#define test_and_set_bit_lock test_and_set_bit
+static __inline__ int test_and_set_bit_lock(int nr, volatile void *addr)
+{
+	return test_and_set_bit(nr, addr);
+}
 
 /**
  * __test_and_set_bit - Set a bit and return its old value

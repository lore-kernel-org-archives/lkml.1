Return-Path: <linux-kernel-owner+w=401wt.eu-S1765326AbZAPJ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765326AbZAPJ1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbZAPJ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:26:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:57299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbZAPJ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:26:40 -0500
Subject: generic swap()
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <wfg@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: L-K <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 10:26:34 +0100
Message-Id: <1232097994.14073.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Where did this patch come from? -- I can't seem to find it on lkml at all..

The reason I ask it that I wonder why swap() has a return value?

---

commit 91f68b7359144aa40bb9668124543d15284750b4
Author: Wu Fengguang <fengguang.wu@intel.com>
Date:   Wed Jan 7 18:09:12 2009 -0800

    generic swap(): introduce global macro swap(a, b)
    
    There have been some local definitions of swap(), it's time to replace
    them all with a uniform one.
    
    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6b8e202..343df9e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -476,6 +476,12 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	__val = __val < __min ? __min: __val;	\
 	__val > __max ? __max: __val; })
 
+
+/*
+ * swap - swap value of @a and @b
+ */
+#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  * @ptr:	the pointer to the member.



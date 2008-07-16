Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYGPUZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYGPUZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYGPUZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:25:27 -0400
Received: from n4a.bullet.mail.ac4.yahoo.com ([76.13.13.67]:31514 "HELO
	n4a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752279AbYGPUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:25:26 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 16:25:26 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 750838.65961.bm@omp118.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=CV0RIgunGUDUo0vxtpZ/JQkpszhdXj8khgcLQh3ix6MbCanrvYbVJoaBF+aYlMbbEGLQj2PyuyvAIMUnoxV6WONXS+mjXZgdgIjZ8E3zHTjABjL/wqnt1ibFotCUY9ch4MsJB/Ffm4eT5eCS2vUXBtCT9bvf+nGsvt7TBc3JolI=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Wed, 16 Jul 2008 13:19:31 -0700 (PDT)
From: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Subject: [PATCH] : A better approach to compute int_sqrt in lib/int_sqrt.c
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <551692.52350.qm@web59507.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody !!
      The patch below is what i think is a better approach to
compute int_sqrt().

What about it ?

Thanks !!

---
--- a/lib/int_sqrt.c    2008-04-17 08:19:44.000000000 +0530
+++ b/lib/int_sqrt.c    2008-07-02 11:37:01.000000000 +0530
@@ -1,4 +1,3 @@
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -7,26 +6,21 @@
  * @x: integer of which to calculate the sqrt
  *
  * A very rough approximation to the sqrt() function.
+ * Improved version from the previous one.
  */
 unsigned long int_sqrt(unsigned long x)
 {
-    unsigned long op, res, one;
-
-    op = x;
-    res = 0;
-
-    one = 1UL << (BITS_PER_LONG - 2);
-    while (one > op)
-        one >>= 2;
-
-    while (one != 0) {
-        if (op >= res + one) {
-            op = op - (res + one);
-            res = res +  2 * one;
-        }
-        res /= 2;
-        one /= 4;
-    }
-    return res;
+    unsigned long ub, lb, m;
+    lb = 1;                /* lower bound */
+    ub = (x >> 5) + 8;        /* upper bound */
+    do {
+        m = (ub + lb) >>  1;    /* middle value */
+        if((m * m) > x)
+            ub = m - 1;
+        else
+            lb = m + 1;
+    } while(ub >= lb);
+    
+    return lb - 1;
 }
 EXPORT_SYMBOL(int_sqrt);



      


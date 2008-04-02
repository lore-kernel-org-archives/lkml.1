Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbYDBVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbYDBVxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764028AbYDBVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:47:57 -0400
Received: from xenotime.net ([66.160.160.81]:50527 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764026AbYDBVr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:47:56 -0400
Date: Wed, 2 Apr 2008 14:47:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au, akpm <akpm@linux-foundation.org>,
       mattilinnanvuori@yahoo.com
Subject: [PATCH] docbook: some kernel-locking fixes
Message-Id: <20080402144750.4837bf17.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Fix a wrong path. Add a chapter about try functions.

http://bugzilla.kernel.org/show_bug.cgi?id=9011

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 Documentation/DocBook/kernel-locking.tmpl |   25 +++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- lin2625-rc8-kdoc.orig/Documentation/DocBook/kernel-locking.tmpl
+++ lin2625-rc8-kdoc/Documentation/DocBook/kernel-locking.tmpl
@@ -290,7 +290,7 @@
      <para>
        If you have a data structure which is only ever accessed from
        user context, then you can use a simple semaphore
-       (<filename>linux/asm/semaphore.h</filename>) to protect it.  This 
+       (<filename>include/asm/semaphore.h</filename>) to protect it.  This
        is the most trivial case: you initialize the semaphore to the number 
        of resources available (usually 1), and call
        <function>down_interruptible()</function> to grab the semaphore, and 
@@ -703,6 +703,29 @@
 </sect1>
 </chapter>
 
+<chapter id="try-variants">
+ <title>The try variants</title>
+
+  <para>
+    <function>spin_trylock()</function> does not spin but returns non-zero if
+    it acquires the spinlock on the first try or 0 if not.
+  </para>
+
+  <para>
+    <function>mutex_trylock()</function> does not suspend your task
+    but returns non-zero if it could lock the mutex on the first try
+    or 0 if not.
+  </para>
+
+  <para>
+    <function>down_trylock()</function> does not suspend your task
+    but returns 0 if it could get the semaphore on the first try or
+    non-zero if not. The return value is the inverse of that of
+    <function>spin_trylock()</function> and <function>mutex_trylock()
+    </function>.
+  </para>
+</chapter>
+
   <chapter id="Examples">
    <title>Common Examples</title>
     <para>


---

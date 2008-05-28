Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYE1FBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYE1FBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYE1FBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:01:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59328 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYE1FBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:01:06 -0400
Date: Tue, 27 May 2008 22:13:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au, akpm <akpm@linux-foundation.org>
Subject: [patch -mmotm] docbook: duplicate kernel-locking doc merge
Message-Id: <20080527221327.dfcb4fb6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Removed duplicated patch lines.

I was checking mmotm (2008-0527) kernel docs and got this error:

xmlto: input does not validate (status 3)
/local/linsrc/mmotm-2008-0527-0032/Documentation/DocBook/kernel-locking.xml:722: element chapter: validity error : ID trylock-functions already defined
<chapter id="trylock-functions">
                               ^
/local/linsrc/mmotm-2008-0527-0032/Documentation/DocBook/kernel-locking.xml:722: element chapter: validity error : ID trylock-functions already defined
Document /local/linsrc/mmotm-2008-0527-0032/Documentation/DocBook/kernel-locking.xml does not validate
make[1]: *** [Documentation/DocBook/kernel-locking.html] Error 3
make[1]: *** Waiting for unfinished jobs....
make: *** [htmldocs] Error 2

Looks like Rusty's doc additions were duplicated.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-locking.tmpl |   25 -------------------------
 1 file changed, 25 deletions(-)

--- mmotm-2008-0527-0032.orig/Documentation/DocBook/kernel-locking.tmpl
+++ mmotm-2008-0527-0032/Documentation/DocBook/kernel-locking.tmpl
@@ -719,31 +719,6 @@
   </para>
 </chapter>
 
-<chapter id="trylock-functions">
- <title>The trylock Functions</title>
-  <para>
-   There are functions that try to acquire a lock only once and immediately
-   return a value telling about success or failure to acquire the lock.
-   They can be used if you need no access to the data protected with the lock
-   when some other thread is holding the lock. You should acquire the lock
-   later if you then need access to the data protected with the lock.
-  </para>
-
-  <para>
-    <function>spin_trylock()</function> does not spin but returns non-zero if
-    it acquires the spinlock on the first try or 0 if not. This function can
-    be used in all contexts like <function>spin_lock</function>: you must have
-    disabled the contexts that might interrupt you and acquire the spin lock.
-  </para>
-
-  <para>
-    <function>mutex_trylock()</function> does not suspend your task
-    but returns non-zero if it could lock the mutex on the first try
-    or 0 if not. This function cannot be safely used in hardware or software
-    interrupt contexts despite not sleeping.
-  </para>
-</chapter>
-
   <chapter id="Examples">
    <title>Common Examples</title>
     <para>

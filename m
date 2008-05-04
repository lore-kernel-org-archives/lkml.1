Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYEDHcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYEDHcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYEDHcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:32:06 -0400
Received: from web52003.mail.re2.yahoo.com ([206.190.49.250]:38013 "HELO
	web52003.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751722AbYEDHcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:32:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Fmb39AMLJLAUZuWlK5fJb453H/Z1RW1BKGxdMoOj+2RO6E7KEOhcoVw2Vu8DN+hdn36oU/R8ALYgoXWbZoixwGHbgUjWDktqdQZ8NqJ67tDlX4g8Rb18Mcpfk05LNil22UmUDdOgePsSIaXlXhsTOHRjEIB2ZvBiCMlmo/1phoE=;
X-YMail-OSG: sFPwT8cVM1lcRFXiR_mSQVD11In0VXkxhSkqVYqx.JJ6Ps9DTiLOfjEOBEuTUYnfzUxRJT.M50g7hV325Q5DeFrITru6DOfiKeGrRSOUZNNTkJ_s_e4FD3E_5Q--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Sun, 4 May 2008 00:32:02 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [patch] doc: add a chapter about trylock functions [Bug 9011]
To: bugme-daemon@kernel-bugs.osdl.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <352345.60081.qm@web52003.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
 
Add a chapter about trylock functions.
http://bugzilla.kernel.org/show_bug.cgi?id=9011
 
Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
 
---
 
--- 
linux-2.6/Documentation/DocBook/kernel-locking.tmpl 2008-05-04 
09:22:20.782075500 +0300
+++ 
linux/Documentation/DocBook/kernel-locking.tmpl 2008-05-04 10:13:16.168549500 
+0300
@@ -702,6 +702,38 
@@
 
 </sect1>
 </chapter>
+<chapter 
id="trylock-functions">
+ <title>The trylock 
Functions</title>
+  <para>
+   There are functions that try 
to acquire a lock only once and immediately
+   return a value telling about 
success or failure to acquire the lock.
+   They can be used if you need no 
access to the data protected with the lock
+   when some other thread is 
holding the lock. You should acquire the lock
+   later if you then need 
access to the data protected with the lock.
+  </para>
+
+  
<para>
+    <function>spin_trylock()</function> does not 
spin but returns non-zero if
+    it acquires the spinlock on the first try 
or 0 if not. This function can
+    be used in all contexts like 
<function>spin_lock</function>: you must have
+    disabled the 
contexts that might interrupt you and acquire the spin lock.
+  
</para>
+
+  <para>
+    
<function>mutex_trylock()</function> does not suspend your 
task
+    but returns non-zero if it could lock the mutex on the first 
try
+    or 0 if not. This function cannot be safely used in hardware or 
software 
+    interrupt contexts despite not sleeping.
+  
</para>
+
+  <para>
+    
<function>down_trylock()</function> does not suspend your 
task
+    but returns 0 if it could get the semaphore on the first try 
or
+    non-zero if not. The return value is the inverse of that of
+    
<function>spin_trylock()</function> and 
<function>mutex_trylock()
+    </function>. 
<function>down_trylock</function> can be used in all contexts.
+  
</para>
+</chapter>
 
   <chapter 
id="Examples">
    <title>Common 
Examples</title>



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbXG1Qef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbXG1Qef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXG1QeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:34:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58824 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbXG1QeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:34:21 -0400
Date: Sat, 28 Jul 2007 09:38:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: kgdb-bugreport@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Cc: jason.wessel@windriver.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] fix kgdb kernel-doc
Message-Id: <20070728093831.8dff0e15.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

No kernel-doc comments in this file, although kgdb.tmpl implies that
it needs some:
Warning(linux-2.6.23-rc1-mm1//kernel/kgdb.c): no structured comments found

Add kernel-doc notation in kgdb.h for:
Warning(linux-2.6.23-rc1-mm1//include/linux/kgdb.h:225): No description found for parameter 'remove_all_hw_break'
Warning(linux-2.6.23-rc1-mm1//include/linux/kgdb.h:225): No description found for parameter 'correct_hw_break'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kgdb.tmpl |    4 +++-
 include/linux/kgdb.h            |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm1.orig/Documentation/DocBook/kgdb.tmpl
+++ linux-2.6.23-rc1-mm1/Documentation/DocBook/kgdb.tmpl
@@ -235,7 +235,9 @@
       and are optionally implemented.  Some functions (with _hw_ in the name)
       end up being required on arches which use hardware breakpoints.
       </para>
-!Ikernel/kgdb.c
+<!--
+X!Ikernel/kgdb.c
+-->
   </chapter>
   <chapter id="DriverSpecificFunctions">
     <title>Driver-Specific Functions</title>
--- linux-2.6.23-rc1-mm1.orig/include/linux/kgdb.h
+++ linux-2.6.23-rc1-mm1/include/linux/kgdb.h
@@ -207,6 +207,10 @@ extern int kgdb_arch_remove_breakpoint(u
  * breakpoint.
  * @remove_hw_breakpoint: Allow an architecture to specify how to remove a
  * hardware breakpoint.
+ * @remove_all_hw_break: Allow an architecture to specify how to remove all
+ * hardware breakpoints.
+ * @correct_hw_break: Allow an architecture to specify how to correct the
+ * hardware debug registers.
  *
  * The @shadowth flag is an option to shadow information not retrievable by
  * gdb otherwise.  This is deprecated in favor of a binutils which supports

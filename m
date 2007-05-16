Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXEPPOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXEPPOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXEPPOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:14:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38934 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbXEPPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:14:00 -0400
Date: Wed, 16 May 2007 08:16:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       akpm <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation:  Fix the explanation of Kconfig files.
Message-Id: <20070516081650.fa3ffca1.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705150517440.20625@localhost.localdomain>
References: <Pine.LNX.4.64.0705150517440.20625@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@mindspring.com>

Fix the obvious errors in the explanation of Kconfig files.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 Documentation/CodingStyle |   51 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

--- linux-2.6.22-rc1.orig/Documentation/CodingStyle
+++ linux-2.6.22-rc1/Documentation/CodingStyle
@@ -495,29 +495,40 @@ re-formatting you may want to take a loo
 remember: "indent" is not a fix for bad programming.
 
 
-		Chapter 10: Configuration-files
+		Chapter 10: Kconfig configuration files
 
-For configuration options (arch/xxx/Kconfig, and all the Kconfig files),
-somewhat different indentation is used.
-
-Help text is indented with 2 spaces.
-
-if CONFIG_EXPERIMENTAL
-	tristate CONFIG_BOOM
-	default n
-	help
-	  Apply nitroglycerine inside the keyboard (DANGEROUS)
-	bool CONFIG_CHEER
-	depends on CONFIG_BOOM
-	default y
+For all of the Kconfig* configuration files throughout the source tree,
+the indentation is somewhat different.  Lines under a "config" definition
+are indented with one tab, while help text is indented an additional two
+spaces.  Example:
+
+config AUDIT
+	bool "Auditing support"
+	depends on NET
 	help
-	  Output nice messages when you explode
-endif
+	  Enable auditing infrastructure that can be used with another
+	  kernel subsystem, such as SELinux (which requires this for
+	  logging of avc messages output).  Does not do system-call
+	  auditing without CONFIG_AUDITSYSCALL.
+
+Features that might still be considered unstable should be defined as
+dependent on "EXPERIMENTAL":
+
+config SLUB
+	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
+	bool "SLUB (Unqueued Allocator)"
+	...
+
+while seriously dangerous features (such as write support for certain
+filesystems) should advertise this prominently in their prompt string:
+
+config ADFS_FS_RW
+	bool "ADFS write support (DANGEROUS)"
+	depends on ADFS_FS
+	...
 
-Generally, CONFIG_EXPERIMENTAL should surround all options not considered
-stable. All options that are known to trash data (experimental write-
-support for file-systems, for instance) should be denoted (DANGEROUS), other
-experimental options should be denoted (EXPERIMENTAL).
+For full documentation on the configuration files, see the file
+Documentation/kbuild/kconfig-language.txt.
 
 
 		Chapter 11: Data structures

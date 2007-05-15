Return-Path: <linux-kernel-owner+w=401wt.eu-S933876AbXEOJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbXEOJVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759220AbXEOJVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:21:15 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45679 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbXEOJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:21:15 -0400
X-Originating-Ip: 72.143.66.196
Date: Tue, 15 May 2007 05:20:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] Documentation:  Fix the explanation of Kconfig files.
Message-ID: <Pine.LNX.4.64.0705150517440.20625@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the obvious errors in the explanation of Kconfig files.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index afc2867..444141e 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -495,29 +495,40 @@ re-formatting you may want to take a look at the man page.  But
 remember: "indent" is not a fix for bad programming.


-		Chapter 10: Configuration-files
+		Chapter 10: Kconfig configuration files

-For configuration options (arch/xxx/Kconfig, and all the Kconfig files),
-somewhat different indentation is used.
+For all of the Kconfig* configuration files throughout the source tree,
+the indentation is somewhat different.  Lines within a "config" definition
+are indented by one tab, while help text is indented an additional two
+spaces:

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
+        bool "ADFS write support (DANGEROUS)"
+        depends on ADFS_FS
+	...

-Generally, CONFIG_EXPERIMENTAL should surround all options not considered
-stable. All options that are known to trash data (experimental write-
-support for file-systems, for instance) should be denoted (DANGEROUS), other
-experimental options should be denoted (EXPERIMENTAL).
+For full documentation on the configuration files, see the file
+Documentation/kbuild/kconfig-language.txt.


 		Chapter 11: Data structures
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

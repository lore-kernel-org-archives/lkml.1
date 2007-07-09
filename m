Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXGIIIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXGIIIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 04:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXGIII2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 04:08:28 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37572 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXGIII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 04:08:27 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 9 Jul 2007 04:05:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Make profiling uniformly non-menu and non-EXPERIMENTAL.
Message-ID: <Pine.LNX.4.64.0707090357580.21984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  the current layout of profiling configuration is a bit of a mess, so
this patch tries to make things uniform across all architectures.

1) it's pointless having some arches define profiling as a separate
menu while others don't, so remove the surrounding menu where it
exists -- it has no value.

2) given how long profiling has been around, it's just as pointless to
keep categorizing it as EXPERIMENTAL, so drop all EXPERIMENTAL labels
and dependencies.  it's particularly meaningless to have Kconfig
entries advertise an option as "EXPERIMENTAL" when there is no such
dependency for that option, only because you assume that you're
getting that dependency from a higher-level Kconfig file, as with
arch/i386/oprofile/Kconfig, shown here in its entirety:

config PROFILING
	bool "Profiling support (EXPERIMENTAL)"
	help
	  Say Y here to enable the extended profiling support mechanisms used
	  by profilers such as OProfile.


config OPROFILE
	tristate "OProfile system profiling (EXPERIMENTAL)"
	depends on PROFILING
	help
	  OProfile is a profiling system capable of profiling the
	  whole system, include the kernel, kernel modules, libraries,
	  and applications.

	  If unsure, say N.


 arch/alpha/oprofile/Kconfig    |   11 ++---------
 arch/arm/oprofile/Kconfig      |   11 ++---------
 arch/blackfin/oprofile/Kconfig |    7 +------
 arch/i386/oprofile/Kconfig     |    4 ++--
 arch/ia64/oprofile/Kconfig     |    4 ++--
 arch/m32r/oprofile/Kconfig     |   11 ++---------
 arch/mips/oprofile/Kconfig     |   13 +++----------
 arch/parisc/oprofile/Kconfig   |   11 ++---------
 arch/powerpc/oprofile/Kconfig  |    4 ++--
 arch/s390/oprofile/Kconfig     |    6 ------
 arch/sh/oprofile/Kconfig       |   11 ++---------
 arch/sh64/oprofile/Kconfig     |   11 ++---------
 arch/sparc/oprofile/Kconfig    |    5 ++---
 arch/sparc64/oprofile/Kconfig  |    5 ++---
 arch/x86_64/oprofile/Kconfig   |    5 ++---
 15 files changed, 28 insertions(+), 91 deletions(-)

diff --git a/arch/alpha/oprofile/Kconfig b/arch/alpha/oprofile/Kconfig
index 5ade198..6f4a40f 100644
--- a/arch/alpha/oprofile/Kconfig
+++ b/arch/alpha/oprofile/Kconfig
@@ -1,16 +1,12 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -18,6 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
-endmenu
-
diff --git a/arch/arm/oprofile/Kconfig b/arch/arm/oprofile/Kconfig
index afd93ad..4b778fc 100644
--- a/arch/arm/oprofile/Kconfig
+++ b/arch/arm/oprofile/Kconfig
@@ -1,16 +1,12 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -37,6 +33,3 @@ config OPROFILE_ARM11_CORE
 	bool

 endif
-
-endmenu
-
diff --git a/arch/blackfin/oprofile/Kconfig b/arch/blackfin/oprofile/Kconfig
index 0a2fd99..9156151 100644
--- a/arch/blackfin/oprofile/Kconfig
+++ b/arch/blackfin/oprofile/Kconfig
@@ -1,8 +1,5 @@
-menu "Profiling support"
-depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
@@ -25,5 +22,3 @@ config HARDWARE_PM
 	  and application.

 	  If unsure, say N.
-
-endmenu
diff --git a/arch/i386/oprofile/Kconfig b/arch/i386/oprofile/Kconfig
index d8a8408..820b02d 100644
--- a/arch/i386/oprofile/Kconfig
+++ b/arch/i386/oprofile/Kconfig
@@ -1,12 +1,12 @@
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
diff --git a/arch/ia64/oprofile/Kconfig b/arch/ia64/oprofile/Kconfig
index 97271ab..9633a5b 100644
--- a/arch/ia64/oprofile/Kconfig
+++ b/arch/ia64/oprofile/Kconfig
@@ -1,11 +1,11 @@
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.

 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
diff --git a/arch/m32r/oprofile/Kconfig b/arch/m32r/oprofile/Kconfig
index 19d3773..958706d 100644
--- a/arch/m32r/oprofile/Kconfig
+++ b/arch/m32r/oprofile/Kconfig
@@ -1,16 +1,12 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -18,6 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
-endmenu
-
diff --git a/arch/mips/oprofile/Kconfig b/arch/mips/oprofile/Kconfig
index fb6f235..e47dbf6 100644
--- a/arch/mips/oprofile/Kconfig
+++ b/arch/mips/oprofile/Kconfig
@@ -1,23 +1,16 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING && !MIPS_MT_SMTC && EXPERIMENTAL
+	tristate "OProfile system profiling"
+	depends on PROFILING && !MIPS_MT_SMTC
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
 	  and applications.

 	  If unsure, say N.
-
-endmenu
-
diff --git a/arch/parisc/oprofile/Kconfig b/arch/parisc/oprofile/Kconfig
index 5ade198..6f4a40f 100644
--- a/arch/parisc/oprofile/Kconfig
+++ b/arch/parisc/oprofile/Kconfig
@@ -1,16 +1,12 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -18,6 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
-endmenu
-
diff --git a/arch/powerpc/oprofile/Kconfig b/arch/powerpc/oprofile/Kconfig
index eb2dece..6110cb0 100644
--- a/arch/powerpc/oprofile/Kconfig
+++ b/arch/powerpc/oprofile/Kconfig
@@ -1,12 +1,12 @@
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
diff --git a/arch/s390/oprofile/Kconfig b/arch/s390/oprofile/Kconfig
index 208220a..406603a 100644
--- a/arch/s390/oprofile/Kconfig
+++ b/arch/s390/oprofile/Kconfig
@@ -1,6 +1,3 @@
-
-menu "Profiling support"
-
 config PROFILING
 	bool "Profiling support"
 	help
@@ -17,6 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
-endmenu
-
diff --git a/arch/sh/oprofile/Kconfig b/arch/sh/oprofile/Kconfig
index 5ade198..6f4a40f 100644
--- a/arch/sh/oprofile/Kconfig
+++ b/arch/sh/oprofile/Kconfig
@@ -1,16 +1,12 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -18,6 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
-endmenu
-
diff --git a/arch/sh64/oprofile/Kconfig b/arch/sh64/oprofile/Kconfig
index 19d3773..958706d 100644
--- a/arch/sh64/oprofile/Kconfig
+++ b/arch/sh64/oprofile/Kconfig
@@ -1,16 +1,12 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -18,6 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
-endmenu
-
diff --git a/arch/sparc/oprofile/Kconfig b/arch/sparc/oprofile/Kconfig
index d8a8408..6f4a40f 100644
--- a/arch/sparc/oprofile/Kconfig
+++ b/arch/sparc/oprofile/Kconfig
@@ -1,12 +1,12 @@
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -14,4 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
diff --git a/arch/sparc64/oprofile/Kconfig b/arch/sparc64/oprofile/Kconfig
index d8a8408..6f4a40f 100644
--- a/arch/sparc64/oprofile/Kconfig
+++ b/arch/sparc64/oprofile/Kconfig
@@ -1,12 +1,12 @@
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -14,4 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-
diff --git a/arch/x86_64/oprofile/Kconfig b/arch/x86_64/oprofile/Kconfig
index d8a8408..6f4a40f 100644
--- a/arch/x86_64/oprofile/Kconfig
+++ b/arch/x86_64/oprofile/Kconfig
@@ -1,12 +1,12 @@
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.


 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	help
 	  OProfile is a profiling system capable of profiling the
@@ -14,4 +14,3 @@ config OPROFILE
 	  and applications.

 	  If unsure, say N.
-

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

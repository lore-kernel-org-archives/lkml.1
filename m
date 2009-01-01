Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbZAATfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbZAATfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZAATfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 14:35:10 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:46954 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZAATfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 14:35:09 -0500
Date: Thu, 1 Jan 2009 20:35:04 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: "David S. Miller" <davem@davemloft.net>, linux-sparc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sparc: Use 64BIT config entry
Message-ID: <20090101193504.GA4368@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-sparc@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Use 64BIT config entry to distinguish between 32 and 64bit builds
instead of relying on the ARCH setting.  Using sparc64 as ARCH still
forces 64BIT on.

Inspired by the x86 and s390 configs.

Signed-off-by: Bastian Blank <waldi@debian.org>

-- 
You can't evaluate a man by logic alone.
		-- McCoy, "I, Mudd", stardate 4513.3

--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=diff

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 0a94d9c..73ddfd9 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -4,6 +4,13 @@
 
 mainmenu "Linux/SPARC Kernel Configuration"
 
+config 64BIT
+	bool "64-bit kernel" if ARCH = "sparc"
+	default ARCH = "sparc64"
+	help
+	  Say yes to build a 64-bit kernel - formerly known as sparc64
+	  Say no to build a 32-bit kernel - formerly known as sparc
+
 config SPARC
 	bool
 	default y
@@ -15,22 +22,11 @@ config SPARC
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 
-# Identify this as a Sparc32 build
 config SPARC32
-	bool
-	default y if ARCH = "sparc"
-	help
-	  SPARC is a family of RISC microprocessors designed and marketed by
-	  Sun Microsystems, incorporated.  They are very widely found in Sun
-	  workstations and clones. This port covers the original 32-bit SPARC;
-	  it is old and stable and usually considered one of the "big three"
-	  along with the Intel and Alpha ports.  The UltraLinux project
-	  maintains both the SPARC32 and SPARC64 ports; its web page is
-	  available at <http://www.ultralinux.org/>.
+	def_bool !64BIT
 
 config SPARC64
-	bool
-	default y if ARCH = "sparc64"
+	def_bool 64BIT
 	select ARCH_SUPPORTS_MSI
 	select HAVE_FUNCTION_TRACER
 	select HAVE_KRETPROBES
@@ -53,9 +49,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config 64BIT
-	def_bool y if SPARC64
-
 config GENERIC_TIME
 	bool
 	default y if SPARC64

--3lcZGd9BuhuYXNfi--

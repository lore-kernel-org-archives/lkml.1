Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYBHNR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYBHNR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbYBHNRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:17:43 -0500
Received: from bb-87-81-255-5.ukonline.co.uk ([87.81.255.5]:52281 "EHLO
	pegasus." rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org with ESMTP
	id S1758677AbYBHNRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:17:42 -0500
X-Greylist: delayed 1791 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 08:17:18 EST
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [PATCH 1/2] i8k - Move Kconfig entry to drivers/char
To: linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Massimo Dal Zotto <dz@debian.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 08 Feb 2008 12:47:26 +0000
Message-ID: <20080208124726.16369.81528.stgit@localhost>
In-Reply-To: <20080208124721.16369.76502.stgit@localhost>
References: <20080208124721.16369.76502.stgit@localhost>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source code for this driver is currently located in drivers/char, and
given that this is not an x86 processor feature, it shouldn't live in the
x86 Kconfig.

So lets move it to the Kconfig for drivers/char instead, and just add
a dependency on x86.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Massimo Dal Zotto <dz@debian.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---

 arch/x86/Kconfig     |   20 --------------------
 drivers/char/Kconfig |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 20 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c95482b..beaf268 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -632,26 +632,6 @@ config TOSHIBA
 	  Say Y if you intend to run this kernel on a Toshiba portable.
 	  Say N otherwise.
 
-config I8K
-	tristate "Dell laptop support"
-	---help---
-	  This adds a driver to safely access the System Management Mode
-	  of the CPU on the Dell Inspiron 8000. The System Management Mode
-	  is used to read cpu temperature and cooling fan status and to
-	  control the fans on the I8K portables.
-
-	  This driver has been tested only on the Inspiron 8000 but it may
-	  also work with other Dell laptops. You can force loading on other
-	  models by passing the parameter `force=1' to the module. Use at
-	  your own risk.
-
-	  For information on utilities to make use of this driver see the
-	  I8K Linux utilities web site at:
-	  <http://people.debian.org/~dz/i8k/>
-
-	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
-	  Say N otherwise.
-
 config X86_REBOOTFIXUPS
 	def_bool n
 	prompt "Enable X86 board specific fixups for reboot"
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index f01ac9a..37861c4 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -867,6 +867,27 @@ config APPLICOM
 
 	  If unsure, say N.
 
+config I8K
+	tristate "Dell laptop support"
+	depends on X86
+	---help---
+	  This adds a driver to safely access the System Management Mode
+	  of the CPU on the Dell Inspiron 8000. The System Management Mode
+	  is used to read cpu temperature and cooling fan status and to
+	  control the fans on the I8K portables.
+
+	  This driver has been tested only on the Inspiron 8000 but it may
+	  also work with other Dell laptops. You can force loading on other
+	  models by passing the parameter `force=1' to the module. Use at
+	  your own risk.
+
+	  For information on utilities to make use of this driver see the
+	  I8K Linux utilities web site at:
+	  <http://people.debian.org/~dz/i8k/>
+
+	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
+	  Say N otherwise.
+
 config SONYPI
 	tristate "Sony Vaio Programmable I/O Control Device support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && X86 && PCI && INPUT && !64BIT


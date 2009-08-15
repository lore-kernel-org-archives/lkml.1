Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZHOLbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZHOLbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZHOLbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:31:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:58557 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZHOLbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=YL+2BPFSgIFEH1mwESJkFw4q4TDKCBHb/0cA/hRYb8dWw8AyeFvPTYcAh0xTM1K8nG
         A30u02WS+JIE7Iwn8Y0IP0JcwglsO894jyMgCsHzpEaF3vzg/Yx6TMHFY5FPySukDQxc
         /zGIwFe8+mzW6uqCRQZOGyDH7+GZliXRdfUzM=
Message-ID: <4A869CA2.4090001@gmail.com>
Date: Sat, 15 Aug 2009 19:31:46 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <linux@arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] ARM: Add nuc950 definition in makefile and kconfig
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

Add nuc950 platform definition in makefile and kconfig.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/Kconfig  |   16 +++++++++++++++-
 arch/arm/mach-w90x900/Makefile |    6 ++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-w90x900/Kconfig b/arch/arm/mach-w90x900/Kconfig
index 8e4178f..c70407c 100644
--- a/arch/arm/mach-w90x900/Kconfig
+++ b/arch/arm/mach-w90x900/Kconfig
@@ -5,15 +5,29 @@ config CPU_W90P910
 	help
 	  Support for W90P910 of Nuvoton W90X900 CPUs.
 
+config CPU_NUC950
+	bool
+	help
+	  Support for NUCP950 of Nuvoton W90X900 CPUs.
+
 menu "W90P910 Machines"
 
 config MACH_W90P910EVB
 	bool "Nuvoton W90P910 Evaluation Board"
-	default y
 	select CPU_W90P910
 	help
 	   Say Y here if you are using the Nuvoton W90P910EVB
 
 endmenu
 
+menu "NUC950 Machines"
+
+config MACH_W90P950EVB
+	bool "Nuvoton NUC950 Evaluation Board"
+	select CPU_NUC950
+	help
+	   Say Y here if you are using the Nuvoton NUC950EVB
+
+endmenu
+
 endif
diff --git a/arch/arm/mach-w90x900/Makefile b/arch/arm/mach-w90x900/Makefile
index 3ccd625..8cdbb91 100644
--- a/arch/arm/mach-w90x900/Makefile
+++ b/arch/arm/mach-w90x900/Makefile
@@ -4,12 +4,14 @@
 
 # Object file lists.
 
-obj-y				:= irq.o time.o mfp-w90p910.o gpio.o clock.o
+obj-y				:= irq.o time.o gpio.o clock.o cpu.o dev.o
 obj-y				+= clksel.o
 # W90X900 CPU support files
 
-obj-$(CONFIG_CPU_W90P910)	+= w90p910.o
+obj-$(CONFIG_CPU_W90P910)	+= w90p910.o mfp-w90p910.o
+obj-$(CONFIG_CPU_NUC950)	+= nuc950.o
 
 # machine support
 
 obj-$(CONFIG_MACH_W90P910EVB)	+= mach-w90p910evb.o
+obj-$(CONFIG_MACH_W90P950EVB)	+= mach-nuc950evb.o
-- 
1.5.6.3


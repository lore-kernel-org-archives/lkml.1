Return-Path: <linux-kernel-owner+w=401wt.eu-S1765460AbXJRNy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765460AbXJRNy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXJRNyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:54:38 -0400
Received: from mx1.minet.net ([157.159.40.25]:57521 "EHLO mx1.minet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860AbXJRNyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:54:37 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Date: Thu, 18 Oct 2007 15:51:24 +0200
Subject: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
MIME-Version: 1.0
X-Length: 2941
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Message-Id: <200710181551.24912.florian.fainelli@telecomint.eu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the generic GPIO support to the x86
architecture. We do the same as for MIPS, we let
the machine override the gpio callbacks and provide
defaults one in mach-generic.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
 arch/i386/Kconfig                   |    4 ++++
 include/asm-x86/gpio.h              |    6 ++++++
 include/asm-x86/mach-generic/gpio.h |   15 +++++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-x86/gpio.h
 create mode 100644 include/asm-x86/mach-generic/gpio.h
---
diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index bf9aafa..501fd6d 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -79,6 +79,10 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config GENERIC_GPIO
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/include/asm-x86/gpio.h b/include/asm-x86/gpio.h
new file mode 100644
index 0000000..ff87fca
--- /dev/null
+++ b/include/asm-x86/gpio.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_I386_GPIO_H
+#define _ASM_I386_GPIO_H
+
+#include <gpio.h>
+
+#endif /* _ASM_I386_GPIO_H */
diff --git a/include/asm-x86/mach-generic/gpio.h b/include/asm-x86/mach-generic/gpio.h
new file mode 100644
index 0000000..5305dcb
--- /dev/null
+++ b/include/asm-x86/mach-generic/gpio.h
@@ -0,0 +1,15 @@
+#ifndef __ASM_MACH_GENERIC_GPIO_H
+#define __ASM_MACH_GENERIC_GPIO_H
+
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+int gpio_direction_input(unsigned gpio);
+int gpio_direction_output(unsigned gpio, int value);
+int gpio_get_value(unsigned gpio);
+void gpio_set_value(unsigned gpio, int value);
+int gpio_to_irq(unsigned gpio);
+int irq_to_gpio(unsigned irq);
+
+#include <asm-generic/gpio.h>           /* cansleep wrappers */
+
+#endif /* __ASM_MACH_GENERIC_GPIO_H */

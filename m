Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYGHMm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYGHMm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbYGHMmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:42:25 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27522 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757063AbYGHMmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:42:23 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 19/58] microblaze_v5: early_printk support
Date: Tue,  8 Jul 2008 13:59:19 +0200
Message-Id: <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/early_printk.c |  130 +++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/early_printk.c

diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
new file mode 100644
index 0000000..54df948
--- /dev/null
+++ b/arch/microblaze/kernel/early_printk.c
@@ -0,0 +1,130 @@
+/*
+ * Early printk support for Microblaze.
+ *
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2003-2006 Yasushi SHOJI <yashi@atmark-techno.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+/* FIXME Once we got some system without uart light, we need to refactor */
+
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/tty.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/fcntl.h>
+#include <asm/setup.h>
+
+#ifdef CONFIG_EARLY_PRINTK
+#define BASE_ADDR ((unsigned char *)CONFIG_EARLY_PRINTK_UARTLITE_ADDRESS)
+
+#define RX_FIFO	BASE_ADDR
+#define TX_FIFO	((unsigned long *)(BASE_ADDR + 4))
+#define STATUS	((unsigned long *)(BASE_ADDR + 8))
+#define CONTROL	((unsigned long *)(BASE_ADDR + 12))
+
+static void early_printk_putc(char c)
+{
+	/*
+	 * Limit how many times we'll spin waiting for TX FIFO status.
+	 * This will prevent lockups if the base address is incorrectly
+	 * set, or any other issue on the UARTLITE.
+	 * This limit is pretty arbitrary, unless we are at about 10 baud
+	 * we'll never timeout on a working UART.
+	 */
+
+	unsigned retries = 10000;
+	while (retries-- && (ioread32(STATUS) & (1<<3)))
+		;
+
+	/* Only attempt the iowrite if we didn't timeout */
+	if(retries)
+		iowrite32((c & 0xff), TX_FIFO);
+}
+
+static void early_printk_write(struct console *unused,
+					const char *s, unsigned n)
+{
+	while (*s && n-- > 0) {
+		early_printk_putc(*s);
+		if (*s == '\n')
+			early_printk_putc('\r');
+		s++;
+	}
+}
+
+static struct console early_serial_console = {
+	.name = "earlyser",
+	.write = early_printk_write,
+	.flags = CON_PRINTBUFFER,
+	.index = -1,
+};
+
+/* Direct interface for emergencies */
+static struct console *early_console = &early_serial_console;
+static int early_console_initialized;
+
+void early_printk(const char *fmt, ...)
+{
+	char buf[512];
+	int n;
+	va_list ap;
+
+	if (early_console_initialized) {
+		va_start(ap, fmt);
+		n = vscnprintf(buf, 512, fmt, ap);
+		early_console->write(early_console, buf, n);
+		va_end(ap);
+	}
+}
+
+static int __initdata keep_early;
+
+int __init setup_early_printk(char *opt)
+{
+	char *space;
+	char buf[256];
+
+	if (early_console_initialized)
+		return 1;
+
+	strlcpy(buf, opt, sizeof(buf));
+	space = strchr(buf, ' ');
+	if (space)
+		*space = 0;
+
+	if (strstr(buf, "keep"))
+		keep_early = 1;
+
+	early_console = &early_serial_console;
+	early_console_initialized = 1;
+	register_console(early_console);
+	return 0;
+}
+#if 0
+static void __init disable_early_printk(void)
+{
+	if (!early_console_initialized || !early_console)
+		return;
+	if (!keep_early) {
+		printk(KERN_INFO "disabling early console\n");
+		unregister_console(early_console);
+		early_console_initialized = 0;
+	} else
+		printk(KERN_INFO "keeping early console\n");
+}
+#endif
+
+__setup("earlyprintk=", setup_early_printk);
+
+#else
+void early_printk(const char *fmt, ...)
+{
+}
+#endif
-- 
1.5.4.GIT


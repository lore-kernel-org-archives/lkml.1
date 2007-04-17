Return-Path: <linux-kernel-owner+w=401wt.eu-S1030726AbXDQPv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030726AbXDQPv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030892AbXDQPv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:51:59 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:56938 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030726AbXDQPv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:51:58 -0400
Date: Wed, 18 Apr 2007 00:51:55 +0900 (JST)
Message-Id: <20070418.005155.25477582.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, device@lanana.org, ralf@linux-mips.org,
       sshtylyov@ru.mvista.com
Subject: [PATCH 1/2] serial_txx9: Use assigned device numbers
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The serial_txx9 driver have abused device numbers (major 4, minor 128)
if CONFIG_SERIAL_TXX9_STDSERIAL was not set.  This patch makes the
driver use proper device numbers assigned for it (major 204, minor
196-203).  I suppose a typical user of this driver set
CONFIG_SERIAL_TXX9_STDSERIAL to Y (i.e. use "ttyS0"), so this patch
would not cause big compatibility issue.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 509ace7..1deb576 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -62,7 +62,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.08";
+static char *serial_version = "1.09";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -70,13 +70,14 @@ static char *serial_name = "TX39/49 Serial driver";
 #if !defined(CONFIG_SERIAL_TXX9_STDSERIAL)
 /* "ttyS" is used for standard serial driver */
 #define TXX9_TTY_NAME "ttyTX"
-#define TXX9_TTY_MINOR_START	(64 + 64)	/* ttyTX0(128), ttyTX1(129) */
+#define TXX9_TTY_MINOR_START	196
+#define TXX9_TTY_MAJOR	204
 #else
 /* acts like standard serial driver */
 #define TXX9_TTY_NAME "ttyS"
 #define TXX9_TTY_MINOR_START	64
-#endif
 #define TXX9_TTY_MAJOR	TTY_MAJOR
+#endif
 
 /* flag aliases */
 #define UPF_TXX9_HAVE_CTS_LINE	UPF_BUGGY_UART

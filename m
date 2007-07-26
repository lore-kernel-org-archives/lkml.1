Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbXGZO4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbXGZO4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXGZO4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:56:35 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:56892 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbXGZO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:56:35 -0400
Date: Thu, 26 Jul 2007 23:57:35 +0900 (JST)
Message-Id: <20070726.235735.25909273.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org
Subject: [PATCH] serial_txx9: Fix printk format mismatch
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the commit 4f640efb3170dbcf99a37a3cc99060647b95428c, "%lx" is
not suitable for p->mapbase (resource_size_t) in 32-bit.  This patch
fixes a compiler warning caused by the mismatch.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 7480dc8..be2ba06 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -1047,8 +1047,9 @@ static int __devinit serial_txx9_probe(struct platform_device *dev)
 		ret = serial_txx9_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%x MEM%lx IRQ%d): %d\n", i,
-				p->iobase, p->mapbase, p->irq, ret);
+				"(IO%x MEM%llx IRQ%d): %d\n", i,
+				p->iobase, (unsigned long long)p->mapbase,
+				p->irq, ret);
 		}
 	}
 	return 0;

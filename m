Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYJFPKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYJFPKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYJFPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:10:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbYJFPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:10:20 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: jim.cromie@gmail.com
Cc: linux-kernel@vger.kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH] pc8736x_gpio: add support for PC87365 chips.
Date: Mon,  6 Oct 2008 17:10:00 +0200
Message-Id: <1223305800-18464-1-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
X-Provags-ID: V01U2FsdGVkX18rPGTgrdhRpBu9/NTMv1q+MIXjP4P57euIAI2
 xddp3cp5Mhlj8zrcpGMw+cRQYZWBsHTKVo9tmMrbVfQ3AfxswZ
 CyynpEcO4bEGTH/hPAyZx5Fy5y0JFKCgxNfZtU+VJA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only compile tested, because i do not own appropriate hardware.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/char/pc8736x_gpio.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index b930de5..3f7da8c 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -41,7 +41,8 @@ static u8 pc8736x_gpio_shadow[4];
 #define SIO_BASE2       0x4E	/* alt command-reg to check */
 
 #define SIO_SID		0x20	/* SuperI/O ID Register */
-#define SIO_SID_VALUE	0xe9	/* Expected value in SuperI/O ID Register */
+#define SIO_SID_PC87365	0xe5	/* Expected value in ID Register for PC87365 */
+#define SIO_SID_PC87366	0xe9	/* Expected value in ID Register for PC87366 */
 
 #define SIO_CF1		0x21	/* chip config, bit0 is chip enable */
 
@@ -91,13 +92,17 @@ static inline int superio_inb(int addr)
 
 static int pc8736x_superio_present(void)
 {
+	int id;
+
 	/* try the 2 possible values, read a hardware reg to verify */
 	superio_cmd = SIO_BASE1;
-	if (superio_inb(SIO_SID) == SIO_SID_VALUE)
+	id = superio_inb(SIO_SID);
+	if (id == SIO_SID_PC87365 || id == SIO_SID_PC87366)
 		return superio_cmd;
 
 	superio_cmd = SIO_BASE2;
-	if (superio_inb(SIO_SID) == SIO_SID_VALUE)
+	id = superio_inb(SIO_SID);
+	if (id == SIO_SID_PC87365 || id == SIO_SID_PC87366)
 		return superio_cmd;
 
 	return 0;
-- 
1.5.5.GIT


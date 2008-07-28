Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYG1POa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYG1POa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYG1POT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:14:19 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:58984 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYG1POR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:14:17 -0400
Date: Tue, 29 Jul 2008 00:16:12 +0900 (JST)
Message-Id: <20080729.001612.79297475.anemo@mba.ocn.ne.jp>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] gpio: Fix build on CONFIG_GPIO_SYSFS=n
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_GENERIC_GPIO=y && CONFIG_GPIO_SYSFS=n, gpio_export() in
asm-generic/gpio.h refers -ENOSYS and causes build error.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c764a8f..0f99ad3 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_GPIO_H
 
 #include <linux/types.h>
+#include <linux/errno.h>
 
 #ifdef CONFIG_GPIOLIB
 

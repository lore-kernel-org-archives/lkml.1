Return-Path: <linux-kernel-owner+w=401wt.eu-S1762844AbZFMAsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762844AbZFMAsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZFMAsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:48:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49019 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZFMAsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:48:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/2] serial: bfin_5xx: fix building as module when early printk is enabled
Date: Fri, 12 Jun 2009 20:48:13 -0400
Message-Id: <1244854093-2156-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244854093-2156-1-git-send-email-vapier@gentoo.org>
References: <1244854093-2156-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since early printk only makes sense/works when the serial driver is built
into the kernel, disable the option for this driver when it is going to be
built as a module.  Otherwise we get build failures due to the ifdef
handling.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index d7fcca1..b4a7650 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -38,6 +38,10 @@
 #include <asm/cacheflush.h>
 #endif
 
+#ifdef CONFIG_SERIAL_BFIN_MODULE
+# undef CONFIG_EARLY_PRINTK
+#endif
+
 /* UART name and device definitions */
 #define BFIN_SERIAL_NAME	"ttyBF"
 #define BFIN_SERIAL_MAJOR	204
-- 
1.6.3.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbYFIVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbYFIVO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbYFIVLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:11:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52570 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757136AbYFIVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:10:51 -0400
Message-Id: <20080609211047.409885034@attica.americas.sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 09 Jun 2008 16:10:39 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 11/11] GRU Driver - makefile & Kconfig file changes
Content-Disposition: inline; filename=gru_makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefile & Kconfig changes for the GRU driver.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/gru/Makefile |    5 +++++
 drivers/misc/Kconfig      |   13 ++++++++++
 5 file changed, 18 insertions(+)

Index: linux/drivers/misc/gru/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/misc/gru/Makefile	2008-06-09 13:53:05.920793394 -0500
@@ -0,0 +1,5 @@
+
+EXTRA_CFLAGS += -DDEBUG -Werror -Wall
+obj-$(CONFIG_SGI_GRU) := gru.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
+
Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig	2008-06-03 21:02:49.000000000 -0500
+++ linux/drivers/misc/Kconfig	2008-06-03 21:07:51.203689479 -0500
@@ -391,4 +391,13 @@ config SGI_XP
 	  this feature will allow for direct communication between SSIs
 	  based on a network adapter and DMA messaging.
 
+config SGI_GRU
+	tristate "SGI GRU driver"
+	depends on X86_64 || IA64
+	default n
+	select MMU_NOTIFIER
+	---help---
+	This option enables basic support for the SGI UV GRU driver. If
+	you are not running on a SGI UV system, say N.
+
 endif # MISC_DEVICES

-- 
Thanks

Jack Steiner (steiner@sgi.com)          651-683-5302
Sr Principal Engineer                   SGI - Silicon Graphics, Inc.



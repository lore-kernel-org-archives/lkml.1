Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbXEaVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbXEaVEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXEaVEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:04:02 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.133]:43711 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbXEaVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:04:00 -0400
Date: Thu, 31 May 2007 13:58:26 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/5] console: console handover to preferred console
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705311358.26559.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/5] console: console handover to preferred console

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/kernel/printk.c b/kernel/printk.c
index 0bbdeac..7b96cae 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -985,12 +1007,15 @@ void register_console(struct console *console)
 	if (!(console->flags & CON_ENABLED))
 		return;
 
-	if (bootconsole) {
+	if (bootconsole && (console->flags & CON_CONSDEV)) {
 		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
 		       bootconsole->name, bootconsole->index,
 		       console->name, console->index);
 		unregister_console(bootconsole);
 		console->flags &= ~CON_PRINTBUFFER;
+	} else {
+		printk(KERN_INFO "console [%s%d] enabled\n",
+		       console->name, console->index);
 	}
 
 	/*

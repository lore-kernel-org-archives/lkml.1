Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbXE3Bsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbXE3Bsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXE3Bsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:48:32 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:30470 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbXE3Bsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:48:30 -0400
Date: Tue, 29 May 2007 18:41:35 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/5] console: console handover to preferred console
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705291841.35613.yinghai.lu@sun.com>
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

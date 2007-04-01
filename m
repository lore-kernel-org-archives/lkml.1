Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbXDASQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbXDASQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbXDASQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:16:06 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39500 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769AbXDASPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:15:43 -0400
Date: Sun, 1 Apr 2007 20:15:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 08/16] console-printk-level.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012007020.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow the printk level to be set using a "conlevel=" parameter.
(Or is there already a different bootoption that does the same thing?)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 printk.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.21-rc5/kernel/printk.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/printk.c
+++ linux-2.6.21-rc5/kernel/printk.c
@@ -747,6 +747,15 @@ void resume_console(void)
 }
 #endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
+static __init int set_conlevel(char *str)
+{
+	if(*str >= '0' && *str <= '9')
+		*console_printk = *str - '0';
+	return 1;
+}
+
+__setup("conlevel=", set_conlevel);
+
 /**
  * acquire_console_sem - lock the console system for exclusive use.
  *
#<EOF>

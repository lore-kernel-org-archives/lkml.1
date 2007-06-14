Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbXFNRXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbXFNRXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXFNRXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:23:12 -0400
Received: from mail.screens.ru ([213.234.233.54]:55350 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbXFNRXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:23:10 -0400
Date: Thu, 14 Jun 2007 21:23:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] adb_probe_task: remove unneeded flush_signals() call
Message-ID: <20070614172335.GA2462@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

adb_probe_task() is forked by "events" thread, all signals are ignored,
no need to play with signal blocking/flushing.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- sig/drivers/macintosh/adb.c~3_adb	2007-05-21 13:57:51.000000000 +0400
+++ sig/drivers/macintosh/adb.c	2007-06-14 21:09:58.000000000 +0400
@@ -248,21 +248,15 @@ static int adb_scan_bus(void)
 static int
 adb_probe_task(void *x)
 {
-	sigset_t blocked;
-
 	strcpy(current->comm, "kadbprobe");
 
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(current);
-
 	printk(KERN_INFO "adb: starting probe task...\n");
 	do_adb_reset_bus();
 	printk(KERN_INFO "adb: finished probe task...\n");
-	
+
 	adb_probe_task_pid = 0;
 	up(&adb_probe_mutex);
-	
+
 	return 0;
 }
 


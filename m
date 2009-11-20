Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZKTQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZKTQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbZKTQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:41:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbZKTQlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:41:07 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: [PATCH 12/15] rtc-m41t80: Use nonseekable_open()
Date: Fri, 20 Nov 2009 17:40:42 +0100
Message-Id: <1258735245-25826-13-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use nonseekable_open() for this since seeking is not supported anyway.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/rtc/rtc-m41t80.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 60fe266..1e2ed76 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -595,10 +595,6 @@ static void wdt_disable(void)
 static ssize_t wdt_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	/*  Can't seek (pwrite) on this device
-	if (ppos != &file->f_pos)
-	return -ESPIPE;
-	*/
 	if (count) {
 		wdt_ping();
 		return 1;
@@ -695,7 +691,7 @@ static int wdt_open(struct inode *inode, struct file *file)
 		 */
 		wdt_is_open = 1;
 		unlock_kernel();
-		return 0;
+		return nonseekable_open(inode, file);
 	}
 	return -ENODEV;
 }
-- 
1.6.4.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZKTQlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZKTQlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZKTQlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:41:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbZKTQlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:41:03 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 10/15] mISDN: Remove unnecessary test on f_pos
Date: Fri, 20 Nov 2009 17:40:40 +0100
Message-Id: <1258735245-25826-11-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test is not doing anything since it is always false if the mISDN_read()
is called from vfs_read(). Besides that the driver uses nonseekable_open()
and is not using off or file->f_pos anywhere.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/isdn/mISDN/timerdev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index 5b7e9bf..0a8b440 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -96,8 +96,6 @@ mISDN_read(struct file *filep, char __user *buf, size_t count, loff_t *off)
 	if (*debug & DEBUG_TIMER)
 		printk(KERN_DEBUG "%s(%p, %p, %d, %p)\n", __func__,
 			filep, buf, (int)count, off);
-	if (*off != filep->f_pos)
-		return -ESPIPE;
 
 	if (list_empty(&dev->expired) && (dev->work == 0)) {
 		if (filep->f_flags & O_NONBLOCK)
-- 
1.6.4.2


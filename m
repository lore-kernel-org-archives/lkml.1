Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXBRXIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXBRXIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXBRXIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:08:31 -0500
Received: from mail.screens.ru ([213.234.233.54]:58819 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbXBRXIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:08:31 -0500
Date: Mon, 19 Feb 2007 02:08:25 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] libata-core: remove akpm's comments
Message-ID: <20070218230825.GA6086@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a small hope this patch is correct (compile tested). At least, the code
was not correct before this patch. "Cancel and flush" should do "Cancel", and
then "flush".

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- WQ/drivers/ata/libata-core.c~4_ata	2007-02-18 22:56:47.000000000 +0300
+++ WQ/drivers/ata/libata-core.c	2007-02-19 02:02:06.000000000 +0300
@@ -1071,8 +1071,6 @@ void ata_port_flush_task(struct ata_port
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
-	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
-
 	/*
 	 * At this point, if a task is running, it's guaranteed to see
 	 * the FLUSH flag; thus, it will never queue pio tasks again.
@@ -1082,8 +1080,8 @@ void ata_port_flush_task(struct ata_port
 		if (ata_msg_ctl(ap))
 			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
 					__FUNCTION__);
-		cancel_work_sync(&ap->port_task.work);
 	}
+	cancel_work_sync(&ap->port_task.work);
 
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags &= ~ATA_PFLAG_FLUSH_PORT_TASK;
@@ -5889,7 +5887,6 @@ void ata_port_detach(struct ata_port *ap
 	/* Flush hotplug task.  The sequence is similar to
 	 * ata_port_flush_task().
 	 */
-	cancel_work_sync(&ap->hotplug_task.work); /* akpm: why? */
 	cancel_delayed_work(&ap->hotplug_task);
 	cancel_work_sync(&ap->hotplug_task.work);
 


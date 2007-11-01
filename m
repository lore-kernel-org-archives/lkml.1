Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXKDWxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXKDWxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 17:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXKDWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 17:53:41 -0500
Received: from flatline.sindominio.net ([82.144.4.26]:42478 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKDWxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 17:53:40 -0500
Date: Thu, 1 Nov 2007 08:19:02 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Prism54: Convert mgmt_sem to the mutex API
Message-ID: <20071101071902.GH6092@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prism54: Convert mgmt_sem to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 219dd65..dbb538c 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -861,7 +861,7 @@ islpci_setup(struct pci_dev *pdev)
 	init_waitqueue_head(&priv->reset_done);
 
 	/* init the queue read locks, process wait counter */
-	sema_init(&priv->mgmt_sem, 1);
+	mutex_init(&priv->mgmt_lock);
 	priv->mgmt_received = NULL;
 	init_waitqueue_head(&priv->mgmt_wqueue);
 	sema_init(&priv->stats_sem, 1);
diff --git a/drivers/net/wireless/prism54/islpci_dev.h b/drivers/net/wireless/prism54/islpci_dev.h
index 736666d..4e0182c 100644
--- a/drivers/net/wireless/prism54/islpci_dev.h
+++ b/drivers/net/wireless/prism54/islpci_dev.h
@@ -26,6 +26,7 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 
 #include "isl_38xx.h"
 #include "isl_oid.h"
@@ -164,7 +165,7 @@ typedef struct {
 	wait_queue_head_t reset_done;
 
 	/* used by islpci_mgt_transaction */
-	struct semaphore mgmt_sem; /* serialize access to mailbox and wqueue */
+	struct mutex mgmt_lock; /* serialize access to mailbox and wqueue */
 	struct islpci_mgmtframe *mgmt_received;	  /* mbox for incoming frame */
 	wait_queue_head_t mgmt_wqueue;            /* waitqueue for mbox */
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

       The yellow ships hung in the air just like bricks dont do
                 (The Hitch-Hiker's Guide to the Galaxy)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

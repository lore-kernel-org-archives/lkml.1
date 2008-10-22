Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYJVRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYJVRej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYJVRcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:32:51 -0400
Received: from kroah.org ([198.145.64.141]:53014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752099AbYJVRcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:32:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Diego Calleja <diegocg@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/42] Staging: Fix leak in drivers/staging/at76_usb.c
Date: Wed, 22 Oct 2008 10:28:46 -0700
Message-Id: <1224696563-5170-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Diego Calleja <diegocg@gmail.com>

Fix leak in at76_usb as reported in:
http://bugzilla.kernel.org/show_bug.cgi?id=11778


Reported-by: Daniel Marjamäki <danielm77@spray.se>
Signed-off-by: Diego Calleja <diegocg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/at76_usb/at76_usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 52df0c6..174e2be 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -2319,9 +2319,11 @@ static int at76_iw_handler_get_scan(struct net_device *netdev,
 	if (!iwe)
 		return -ENOMEM;
 
-	if (priv->scan_state != SCAN_COMPLETED)
+	if (priv->scan_state != SCAN_COMPLETED) {
 		/* scan not yet finished */
+		kfree(iwe);
 		return -EAGAIN;
+	}
 
 	spin_lock_irqsave(&priv->bss_list_spinlock, flags);
 
-- 
1.6.0.2


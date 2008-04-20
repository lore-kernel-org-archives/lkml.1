Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbYDTKov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbYDTKov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbYDTKk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56294 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbYDTKkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, Pavel Machek <pavel@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/36] power_state: remove it from driver core
Date: Sun, 20 Apr 2008 03:45:45 -0700
Message-Id: <1208688366-9252-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

power_state is scheduled for removal, and it is used only for debug
prints by driver core. Remove it.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index d887d5c..26de2c0 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -377,11 +377,6 @@ static int suspend_device(struct device *dev, pm_message_t state)
 
 	down(&dev->sem);
 
-	if (dev->power.power_state.event) {
-		dev_dbg(dev, "PM: suspend %d-->%d\n",
-			dev->power.power_state.event, state.event);
-	}
-
 	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
-- 
1.5.4.5


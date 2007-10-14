Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXJNSfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXJNSfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762601AbXJNSem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:34:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47912 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762537AbXJNSel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:34:41 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fw-cdev __user annotations
Cc: linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de
Message-Id: <E1Ih8IS-00041I-60@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:34:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/firewire/fw-cdev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 7538864..0647130 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -722,10 +722,11 @@ static int ioctl_queue_iso(struct client *client, void *buffer)
 		buffer_end = 0;
 	}
 
-	if (!access_ok(VERIFY_READ, request->packets, request->size))
+	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(request->packets);
+
+	if (!access_ok(VERIFY_READ, p, request->size))
 		return -EFAULT;
 
-	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(request->packets);
 	end = (void __user *)p + request->size;
 	count = 0;
 	while (p < end) {
-- 
1.5.3.GIT



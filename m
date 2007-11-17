Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbXKQALV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbXKQALV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 19:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbXKQALM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 19:11:12 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:46415 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbXKQALL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 19:11:11 -0500
From: Timur Tabi <timur@freescale.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Timur Tabi <timur@freescale.com>
Subject: Add a private_data pointer to struct device_attribute
Date: Fri, 16 Nov 2007 18:11:00 -0600
Message-Id: <11952582603203-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A private data pointer in struct device_attribute allows the 'show' and 'store'
functions to access instance data.  This handy in situations where the
driver_data and platform_data pointers of 'struct device' are already used
for other purposes.

Signed-off-by: Timur Tabi <timur@freescale.com>
---

Greg, can you tell me if you think this patch is a good idea?  It doesn't
appear to do any harm, and I'm working on an ALSA driver that could benefit
for this patch.  I think 2.6.25 would be a good target.

 include/linux/device.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 2e15822..10708ee 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -344,6 +344,7 @@ struct device_attribute {
 			char *buf);
 	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
+	void *private_data;
 };
 
 #define DEVICE_ATTR(_name,_mode,_show,_store) \
-- 
1.5.2.4


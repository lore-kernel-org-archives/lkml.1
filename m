Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYEYKcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYEYKcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762100AbYEYKYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762571AbYEYKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:18 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 25/28] firmware: make fw->data const
Message-Id: <E1K0DON-0007EO-Bt@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:55 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for supporting firmware files linked into the static
kernel, make fw->data const to ensure that users aren't modifying it (so
that we can pass a pointer to the original in-kernel copy, rather than
having to copy it).

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/base/firmware_class.c |    2 +-
 include/linux/firmware.h      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 9fd4a85..264b3a2 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -257,7 +257,7 @@ firmware_data_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 	if (retval)
 		goto out;
 
-	memcpy(fw->data + offset, buffer, count);
+	memcpy((u8 *)fw->data + offset, buffer, count);
 
 	fw->size = max_t(size_t, offset + count, fw->size);
 	retval = count;
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 4d10c73..5e73f3f 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -8,7 +8,7 @@
 
 struct firmware {
 	size_t size;
-	u8 *data;
+	const u8 *data;
 };
 
 struct device;
-- 
1.5.4.5


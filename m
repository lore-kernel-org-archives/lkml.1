Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbZABKqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbZABKqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbZABKl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:57 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:48883 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbZABKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:41 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Philip Blundell <philb@gnu.org>
Subject: [PATCH] m68k: dio - kill resource_size_t format warnings
Date: Fri,  2 Jan 2009 11:41:29 +0100
Message-Id: <1230892892-25751-17-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-16-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-12-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-13-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-14-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-15-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-16-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: format '%08lx' expects type 'long unsigned int', but argument 3 has
type 'resource_size_t'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philip Blundell <philb@gnu.org>
---
 drivers/dio/dio-sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dio/dio-sysfs.c b/drivers/dio/dio-sysfs.c
index 91d5f4d..ee1a3b5 100644
--- a/drivers/dio/dio-sysfs.c
+++ b/drivers/dio/dio-sysfs.c
@@ -58,7 +58,8 @@ static ssize_t dio_show_resource(struct device *dev, struct device_attribute *at
 	struct dio_dev *d = to_dio_dev(dev);
 
 	return sprintf(buf, "0x%08lx 0x%08lx 0x%08lx\n",
-		       dio_resource_start(d), dio_resource_end(d),
+		       (unsigned long)dio_resource_start(d),
+		       (unsigned long)dio_resource_end(d),
 		       dio_resource_flags(d));
 }
 static DEVICE_ATTR(resource, S_IRUGO, dio_show_resource, NULL);
-- 
1.5.6.5


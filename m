Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYJPR1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYJPR1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbYJPROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:53 -0400
Received: from kroah.org ([198.145.64.141]:47015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756417AbYJPROw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/46] Driver core: make bus_find_device_by_name() more robust
Date: Thu, 16 Oct 2008 10:10:35 -0700
Message-Id: <1224177047-11859-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Korsgaard <jacmet@sunsite.dk>

Use sysfs_streq() in bus_find_device_by_name() so trailing newlines
are ignored (E.G. in bind/unbind).

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index ef522ae..39b9b58 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -333,9 +333,7 @@ static int match_name(struct device *dev, void *data)
 {
 	const char *name = data;
 
-	if (strcmp(name, dev->bus_id) == 0)
-		return 1;
-	return 0;
+	return sysfs_streq(name, dev->bus_id);
 }
 
 /**
-- 
1.6.0.2


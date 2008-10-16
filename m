Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYJPR1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYJPR1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbYJPROw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:52 -0400
Received: from kroah.org ([198.145.64.141]:47010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755319AbYJPROu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/46] debug: use dev_WARN() rather than WARN_ON() in device_pm_add()
Date: Thu, 16 Oct 2008 10:10:33 -0700
Message-Id: <1224177047-11859-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

device_pm_add() has a WARN_ON that is showing relatively high on
kerneloops.org, but unfortunately the WARN_ON is less than useful
in that it doesn't print any information about what device is causing
the issue.

This patch fixes this by turning the WARN_ON() into the newly
introduces dev_WARN() which will print information about the
device in question.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 273a944..b0eb6af 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -83,7 +83,7 @@ void device_pm_add(struct device *dev)
 		 * transition is in progress in order to avoid leaving them
 		 * unhandled down the road
 		 */
-		WARN_ON(true);
+		dev_WARN(dev, "Parentless device registered during a PM transaction\n");
 	}
 
 	list_add_tail(&dev->power.entry, &dpm_list);
-- 
1.6.0.2


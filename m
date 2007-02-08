Return-Path: <linux-kernel-owner+w=401wt.eu-S1422876AbXBHAlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422876AbXBHAlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422855AbXBHAlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:41:07 -0500
Received: from mx1.suse.de ([195.135.220.2]:56355 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422876AbXBHAbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:31:45 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/28] driver core: Remove device_is_registered() in device_move().
Date: Wed,  7 Feb 2007 16:29:53 -0800
Message-Id: <11708946362677-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946283719-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

device_is_registered() will always be false for a device with no bus. Remove
this check and trust the caller to know what they're doing.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 67b79a7..36eedfd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1004,10 +1004,6 @@ int device_move(struct device *dev, struct device *new_parent)
 	if (!dev)
 		return -EINVAL;
 
-	if (!device_is_registered(dev)) {
-		error = -EINVAL;
-		goto out;
-	}
 	new_parent = get_device(new_parent);
 	if (!new_parent) {
 		error = -EINVAL;
-- 
1.4.4.4


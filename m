Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYJPRZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYJPRZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYJPROq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:46 -0400
Received: from kroah.org ([198.145.64.141]:46995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756344AbYJPROp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/46] Driver core: Fix cleanup in device_create_vargs().
Date: Thu, 16 Oct 2008 10:10:29 -0700
Message-Id: <1224177047-11859-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

If device_register() in device_create_vargs() fails, the device
must be cleaned up with put_device() (which is also fine on NULL)
instead of kfree().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index aac91e8..9649d1c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1256,7 +1256,7 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
 	return dev;
 
 error:
-	kfree(dev);
+	put_device(dev);
 	return ERR_PTR(retval);
 }
 EXPORT_SYMBOL_GPL(device_create_vargs);
-- 
1.6.0.2


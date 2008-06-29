Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYF2FcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYF2FcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYF2FcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:32:12 -0400
Received: from gate.ebshome.net ([208.106.21.240]:47173 "EHLO gate.ebshome.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYF2FcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:32:12 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2008 01:32:11 EDT
Date: Sat, 28 Jun 2008 22:25:30 -0700
From: Eugene Surovegin <ebs@ebshome.net>
To: linux-kernel@vger.kernel.org
Cc: Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH] RapidIO: fix device reference counting
Message-ID: <20080629052530.GC5860@gate.ebshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ICQ-UIN: 1193073
X-Operating-System: Linux i686
X-PGP-Key: http://www.ebshome.net/pubkey.asc
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix RapidIO device reference counting.

Signed-of-by: Eugene Surovegin <ebs@ebshome.net>
---

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index 3ce9f3d..956d3e7 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -101,8 +101,8 @@ static int rio_device_probe(struct device *dev)
 		if (error >= 0) {
 			rdev->driver = rdrv;
 			error = 0;
+		} else
 			rio_dev_put(rdev);
-		}
 	}
 	return error;
 }


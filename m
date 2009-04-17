Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZDQTHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZDQTHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZDQTHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:24 -0400
Received: from kroah.org ([198.145.64.141]:51194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbZDQTHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/10] driver core: fix driver_match_device
Date: Fri, 17 Apr 2009 12:04:26 -0700
Message-Id: <1239995074-4065-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch fixes a bug introduced in commit
49b420a13ff95b449947181190b08367348e3e1b.

If a instance of bus_type doesn't have  .match method,
all .probe of drivers in the bus should be called, or else
the .probe have not a chance to be called.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index ddc9749..b528145 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -115,7 +115,7 @@ extern int driver_probe_device(struct device_driver *drv, struct device *dev);
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
 {
-	return drv->bus->match && drv->bus->match(dev, drv);
+	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
 }
 
 extern void sysdev_shutdown(void);
-- 
1.6.2


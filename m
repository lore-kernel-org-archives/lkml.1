Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZC0NuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZC0NuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZC0NuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:50:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:28710 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZC0NuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LnahthxY7pJT+XKcM1qAW+iMsRg1kIP+uIJwHi8/4lWOs/5zPBxIHJ7JxpaTmv4i6S
         QvJTu3CDdTd5sreijxKSIiHO1GsYsTJ5HSYNfDMd40NOh693Qsuf+ZE+TRaj8rrBm+If
         Ju4s+Fu12jFQ6VkoR1qTyktqlK/jLUDOQ+Bsk=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core:fix driver_match_device
Date: Fri, 27 Mar 2009 21:50:00 +0800
Message-Id: <1238161800-4714-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
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
1.6.0.GIT


Return-Path: <linux-kernel-owner+w=401wt.eu-S969638AbXFHUFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969638AbXFHUFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969435AbXFHUEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:04:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:38704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969024AbXFHUEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:04:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] Driver core: kill unused code
Date: Fri,  8 Jun 2007 13:04:41 -0700
Message-Id: <118133309258-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813330873231-git-send-email-gregkh@suse.de>
References: <20070608200407.GA22825@kroah.com>
 <11813330832783-git-send-email-gregkh@suse.de>
 <11813330873231-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>

  CC      drivers/base/dd.o
drivers/base/dd.c:211: warning: =E2=80=98device_probe_drivers=E2=80=99 defi=
ned but not used

Looks like the following is dead.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 92428e5..b0088b0 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -207,19 +207,6 @@ static int __device_attach(struct device_driver * drv, void * data)
 	return driver_probe_device(drv, dev);
 }
 
-static int device_probe_drivers(void *data)
-{
-	struct device *dev = data;
-	int ret = 0;
-
-	if (dev->bus) {
-		down(&dev->sem);
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-		up(&dev->sem);
-	}
-	return ret;
-}
-
 /**
  *	device_attach - try to attach device to a driver.
  *	@dev:	device.
-- 
1.5.2.1


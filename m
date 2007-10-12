Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbXJLWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbXJLWhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932421AbXJLWUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:49755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568AbXJLWUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Markus Rechberger <markus.rechberger@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/75] Fix Firmware class name collision
Date: Fri, 12 Oct 2007 15:16:37 -0700
Message-Id: <1192227593813-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227589276-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Rechberger <markus.rechberger@amd.com>

following patch fixes the i2c name collision with i2c-dev.

http://mcentral.de/wiki/index.php/Bugtracker#i2c_core_problem

This issue has been experienced with em28xx and saa7133 based devices.
I discussed that problem with Jean Delvare a while ago and he proposed
to add a prefix to the class name.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4a1b9bf..0295855 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -292,8 +292,7 @@ firmware_class_timeout(u_long data)
 
 static inline void fw_setup_device_id(struct device *f_dev, struct device *dev)
 {
-	/* XXX warning we should watch out for name collisions */
-	strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
+	snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s", dev->bus_id);
 }
 
 static int fw_register_device(struct device **dev_p, const char *fw_name,
-- 
1.5.3.4


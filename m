Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbXJLWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbXJLWdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932513AbXJLWTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:49715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509AbXJLWTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/75] dmi-id: Possible cleanup
Date: Fri, 12 Oct 2007 15:16:31 -0700
Message-Id: <11922275642378-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <119222756066-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

The DEFINE_DMI_ATTR macro has a single user left so we can expand it
for slightly shorter/simpler code.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/dmi-id.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index a7bd87d..b6e1eb7 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -20,10 +20,6 @@ struct dmi_device_attribute{
 #define to_dmi_dev_attr(_dev_attr) \
 	container_of(_dev_attr, struct dmi_device_attribute, dev_attr)
 
-#define DEFINE_DMI_ATTR(_name, _mode, _show)		\
-static struct device_attribute sys_dmi_##_name##_attr =	\
-	__ATTR(_name, _mode, _show, NULL);
-
 static ssize_t sys_dmi_field_show(struct device *dev,
 				  struct device_attribute *attr,
 				  char *page)
@@ -135,7 +131,8 @@ static ssize_t sys_dmi_modalias_show(struct device *dev,
 	return r+1;
 }
 
-DEFINE_DMI_ATTR(modalias, 0444, sys_dmi_modalias_show);
+static struct device_attribute sys_dmi_modalias_attr =
+	__ATTR(modalias, 0444, sys_dmi_modalias_show, NULL);
 
 static struct attribute *sys_dmi_attributes[DMI_STRING_MAX+2];
 
-- 
1.5.3.4


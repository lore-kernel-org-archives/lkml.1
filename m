Return-Path: <linux-kernel-owner+w=401wt.eu-S965713AbXBHAjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713AbXBHAjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422938AbXBHAc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:26 -0500
Received: from ns2.suse.de ([195.135.220.15]:34045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422928AbXBHAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:15 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/28] driver core fixes: device_register() retval check in platform.c
Date: Wed,  7 Feb 2007 16:30:02 -0800
Message-Id: <11708946672133-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1170894664547-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Check the return value of device_register() in platform_bus_init().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f9c903b..30480f6 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -611,8 +611,15 @@ EXPORT_SYMBOL_GPL(platform_bus_type);
 
 int __init platform_bus_init(void)
 {
-	device_register(&platform_bus);
-	return bus_register(&platform_bus_type);
+	int error;
+
+	error = device_register(&platform_bus);
+	if (error)
+		return error;
+	error =  bus_register(&platform_bus_type);
+	if (error)
+		device_unregister(&platform_bus);
+	return error;
 }
 
 #ifndef ARCH_HAS_DMA_GET_REQUIRED_MASK
-- 
1.4.4.4


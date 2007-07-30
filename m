Return-Path: <linux-kernel-owner+w=401wt.eu-S969452AbXG3WLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969452AbXG3WLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968787AbXG3WKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:31 -0400
Received: from ns1.suse.de ([195.135.220.2]:40376 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969173AbXG3WKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/11] kobject: put kobject_actions in kobject.h
Date: Mon, 30 Jul 2007 15:09:26 -0700
Message-Id: <11858333853388-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11858333823900-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
 <11858333823900-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents the extern declaration in the driver core.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c     |    2 --
 include/linux/kobject.h |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 3599ab2..b9bb399 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -24,8 +24,6 @@
 #include "base.h"
 #include "power/power.h"
 
-extern const char *kobject_actions[];
-
 int (*platform_notify)(struct device * dev) = NULL;
 int (*platform_notify_remove)(struct device * dev) = NULL;
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index aa2fe22..49a08f8 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -56,6 +56,9 @@ enum kobject_action {
 	KOBJ_MAX
 };
 
+/* The list of strings defining the valid kobject actions as specified above */
+extern const char *kobject_actions[];
+
 struct kobject {
 	const char		* k_name;
 	char			name[KOBJ_NAME_LEN];
-- 
1.5.2.2


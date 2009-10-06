Return-Path: <linux-kernel-owner+w=401wt.eu-S933639AbZJFWTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbZJFWTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933627AbZJFWTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:31 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:41029 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622AbZJFWT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:29 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 04/11] gigaset: announce if built with debugging
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <isdn@linux-pingi.de>,
       Karsten Keil <keil@b1-systems.de>, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-gigaset-04.tilman@imap.cc>
In-Reply-To: <20091006-patch-gigaset-00.tilman@imap.cc>
References: <20091006-patch-gigaset-00.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:41 +0200 (CEST)
X-Spam-Score: -2.132 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention in the driver load announcement whether the driver was built
with debugging messages enabled, to facilitate support.

Impact: informational message
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/common.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index e4141bf..edbcaa3 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -22,6 +22,12 @@
 #define DRIVER_AUTHOR "Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>, Stefan Eilers"
 #define DRIVER_DESC "Driver for Gigaset 307x"
 
+#ifdef CONFIG_GIGASET_DEBUG
+#define DRIVER_DESC_DEBUG " (debug build)"
+#else
+#define DRIVER_DESC_DEBUG ""
+#endif
+
 /* Module parameters */
 int gigaset_debuglevel = DEBUG_DEFAULT;
 EXPORT_SYMBOL_GPL(gigaset_debuglevel);
@@ -1110,7 +1116,7 @@ static int __init gigaset_init_module(void)
 	if (gigaset_debuglevel == 1)
 		gigaset_debuglevel = DEBUG_DEFAULT;
 
-	pr_info(DRIVER_DESC "\n");
+	pr_info(DRIVER_DESC DRIVER_DESC_DEBUG "\n");
 	return 0;
 }
 
-- 
1.6.2.1.214.ge986c


Return-Path: <linux-kernel-owner+w=401wt.eu-S965149AbXBYV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149AbXBYV7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965154AbXBYV7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:59:21 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:52268 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965149AbXBYV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:59:20 -0500
Subject: Re: [PATCH 3/7] cxgb3 - FW version update
From: Steve Wise <swise@opengridcomputing.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <45E1E810.2000706@garzik.org>
References: <20070225004401.20831.3292.stgit@localhost.localdomain>
	 <1172431719.4717.8.camel@stevo-laptop>  <45E1E810.2000706@garzik.org>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 15:59:18 -0600
Message-Id: <1172440758.4717.17.camel@stevo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I would rather fix the code to use constants, and thus avoid this 
> problem ever happening again.
> 
> 	Jeff
> 

How's this (not tested)?


---

 drivers/net/cxgb3/t3_hw.c   |    6 ++++--
 drivers/net/cxgb3/version.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 365a7f5..4b4cffb 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -884,11 +884,13 @@ int t3_check_fw_version(struct adapter *
 	major = G_FW_VERSION_MAJOR(vers);
 	minor = G_FW_VERSION_MINOR(vers);
 
-	if (type == FW_VERSION_T3 && major == 3 && minor == 1)
+	if (type == FW_VERSION_T3 && major == FW_VERSION_MAJOR && 
+	    minor == FW_VERSION_MINOR)
 		return 0;
 
 	CH_ERR(adapter, "found wrong FW version(%u.%u), "
-	       "driver needs version 3.1\n", major, minor);
+	       "driver needs version %u.%u\n", major, minor, 
+	       FW_VERSION_MAJOR, FW_VERSION_MINOR);
 	return -EINVAL;
 }
 
diff --git a/drivers/net/cxgb3/version.h b/drivers/net/cxgb3/version.h
index 2b67dd5..782a6cf 100644
--- a/drivers/net/cxgb3/version.h
+++ b/drivers/net/cxgb3/version.h
@@ -36,4 +36,6 @@ #define DRV_DESC "Chelsio T3 Network Dri
 #define DRV_NAME "cxgb3"
 /* Driver version */
 #define DRV_VERSION "1.0"
+#define FW_VERSION_MAJOR 3
+#define FW_VERSION_MINOR 2
 #endif				/* __CHELSIO_VERSION_H */



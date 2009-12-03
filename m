Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZLCPhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZLCPhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZLCPg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:36:59 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:27280 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZLCPg6 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 3 Dec 2009 10:36:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org
Cc: armbru@redhat.com, jeremy@goop.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] fb-defio: Inhibit VM_IO flag to be set on vmalloc-ed framebuffers.
Date: Thu,  3 Dec 2009 10:31:58 -0500
Message-Id: <1259854318-16907-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259854318-16907-3-git-send-email-konrad.wilk@oracle.com>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
 <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
 <1259854318-16907-3-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B17DB0A.0136:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The framebuffers (screenbase) these drivers present are actually
vmalloc-ed pages. There is no need for them to have the VM_IO flag set.
---
 drivers/video/broadsheetfb.c |    2 +-
 drivers/video/hecubafb.c     |    2 +-
 drivers/video/metronomefb.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
index 509cb92..df9ccb9 100644
--- a/drivers/video/broadsheetfb.c
+++ b/drivers/video/broadsheetfb.c
@@ -470,7 +470,7 @@ static int __devinit broadsheetfb_probe(struct platform_device *dev)
 	par->read_reg = broadsheet_read_reg;
 	init_waitqueue_head(&par->waitq);
 
-	info->flags = FBINFO_FLAG_DEFAULT;
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &broadsheetfb_defio;
 	fb_deferred_io_init(info);
diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index 0b4bffb..f9d77ad 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -253,7 +253,7 @@ static int __devinit hecubafb_probe(struct platform_device *dev)
 	par->send_command = apollo_send_command;
 	par->send_data = apollo_send_data;
 
-	info->flags = FBINFO_FLAG_DEFAULT;
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &hecubafb_defio;
 	fb_deferred_io_init(info);
diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index df1f757..661bfd2 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -700,7 +700,7 @@ static int __devinit metronomefb_probe(struct platform_device *dev)
 	if (retval < 0)
 		goto err_free_irq;
 
-	info->flags = FBINFO_FLAG_DEFAULT;
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &metronomefb_defio;
 	fb_deferred_io_init(info);
-- 
1.6.2.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbXGEQz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbXGEQz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759013AbXGEQzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:55:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:28564 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612AbXGEQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PSzVVtCFMvOP7BifjqfKTfMYXviuXhDE6syFRUC86N/stCnB12b89I070J6OwZIsJH9hp2VYdbDASMpaM9S7i8rL+B7VgLbX3KsxArqPsoJjYbir+DzSp9/29xxoXyt2BrIlzETKFHE4TbaqWC4qiA+ihwK/SQGrKUb3N8arfcU=
Date: Thu, 5 Jul 2007 20:55:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] Sky Cpu and Nexus: check for create_proc_entry ret code
Message-ID: <20070705165537.GE7180@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking of create_proc_entry call
to prevent possible NULL pointer usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 drivers/misc/hdpuftrs/hdpu_nexus.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index 01bc917..cc81853 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -78,10 +78,20 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 	}
 
 	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
-	hdpu_slot_id->read_proc = hdpu_slot_id_read;
+	if (!hdpu_slot_id) {
+		printk(KERN_WARNING "sky_nexus: "
+		       "Unable to create proc dir entry: sky_slot_id\n");
+	} else {
+		hdpu_slot_id->read_proc = hdpu_slot_id_read;
+	}
 
 	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
-	hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+	if (!hdpu_chassis_id) {
+		printk(KERN_WARNING "sky_nexus: "
+		       "Unable to create proc dir entry: sky_chassis_id\n");
+	} else {
+		hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+	}
 
 	return 0;
 }

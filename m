Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZIXNh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZIXNh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZIXNh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:37:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:51912 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZIXNh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HUco4QvZK7A4IpdNs16PMI3vWn+kpAHOfLFR3NB7w55NQwTW5o1UenSNNfOHZM3/ka
         RP4tB8QHEBP2PlYA8SyUxnTXI2r4nn2CVNc8XvQUaLaceNq1Qc4+0BUZOb9QafQeQz+T
         Qw0dWZD5Rd2Yqn2F40XKbhRQDIP8XPafNh4C8=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next] cciss: fix build when !PROC_FS
Date: Thu, 24 Sep 2009 17:37:19 +0400
Message-Id: <1253799439-7206-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix these build errors when CONFIG_PROC_FS is not set:
drivers/block/cciss.c: In function 'cciss_show_raid_level':
drivers/block/cciss.c:623: error: 'RAID_UNKNOWN' undeclared (first use in this function)
drivers/block/cciss.c:626: error: 'raid_label' undeclared (first use in this function)
drivers/block/cciss.c: In function 'cciss_geometry_inquiry':
drivers/block/cciss.c:2696: error: 'RAID_UNKNOWN' undeclared (first use in this function)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/block/cciss.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4d879b7..78852b1 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -256,6 +256,11 @@ static inline void removeQ(CommandList_struct *c)
 
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
+static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
+	"UNKNOWN"
+};
+#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0])-1)
+
 #ifdef CONFIG_PROC_FS
 
 /*
@@ -264,10 +269,6 @@ static inline void removeQ(CommandList_struct *c)
 #define ENG_GIG 1000000000
 #define ENG_GIG_FACTOR (ENG_GIG/512)
 #define ENGAGE_SCSI	"engage scsi"
-static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
-	"UNKNOWN"
-};
-#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0])-1)
 
 static struct proc_dir_entry *proc_cciss;
 
-- 
1.6.5.rc1


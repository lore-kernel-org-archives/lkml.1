Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbZIQSsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbZIQSsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZIQSsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:48:50 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32008 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215AbZIQSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:47:47 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/20] cciss: fix some magic numbers in the raid-level decoding
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:48:15 -0500
Message-ID: <20090917184815.15105.11105.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cciss: fix some magic numbers in the raid-level decoding

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a8684d0..84f15ec 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -254,8 +254,6 @@ static inline void removeQ(CommandList_struct *c)
 
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
-#define RAID_UNKNOWN 6
-
 #ifdef CONFIG_PROC_FS
 
 /*
@@ -267,6 +265,7 @@ static inline void removeQ(CommandList_struct *c)
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };
+#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0])-1)
 
 static struct proc_dir_entry *proc_cciss;
 
@@ -340,7 +339,7 @@ static int cciss_seq_show(struct seq_file *seq, void *v)
 	vol_sz_frac *= 100;
 	sector_div(vol_sz_frac, ENG_GIG_FACTOR);
 
-	if (drv->raid_level > 5)
+	if (drv->raid_level < 0 || drv->raid_level > RAID_UNKNOWN)
 		drv->raid_level = RAID_UNKNOWN;
 	seq_printf(seq, "cciss/c%dd%d:"
 			"\t%4u.%02uGB\tRAID %s\n",


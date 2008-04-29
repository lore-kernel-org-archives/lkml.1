Return-Path: <linux-kernel-owner+w=401wt.eu-S1763497AbYD2LRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763497AbYD2LRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761718AbYD2LNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20772 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761659AbYD2LNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:33 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, <iss_storagedev@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/12] cciss: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:17 +0400
Message-Id: <1209467602-20001-7-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: <iss_storagedev@hp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/cciss.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e539be5..e336b05 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -428,13 +428,9 @@ static void __devinit cciss_procinit(int i)
 		proc_cciss = proc_mkdir("driver/cciss", NULL);
 	if (!proc_cciss)
 		return;
-	pde = proc_create(hba[i]->devname, S_IWUSR | S_IRUSR | S_IRGRP |
+	pde = proc_create_data(hba[i]->devname, S_IWUSR | S_IRUSR | S_IRGRP |
 					S_IROTH, proc_cciss,
-					&cciss_proc_fops);
-	if (!pde)
-		return;
-
-	pde->data = hba[i];
+					&cciss_proc_fops, hba[i]);
 }
 #endif				/* CONFIG_PROC_FS */
 
-- 
1.5.3.rc5


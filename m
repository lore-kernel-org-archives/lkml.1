Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYDHLTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYDHLTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYDHLTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31093 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbYDHLTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:18 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 10/29] mm: use non-racy method for /proc/swaps creation
Date: Tue,  8 Apr 2008 15:19:17 +0400
Message-Id: <1207653576-12640-10-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing
PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 mm/swapfile.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 67051be..bd1bb59 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1426,11 +1426,7 @@ static const struct file_operations proc_swaps_operations = {
 
 static int __init procswaps_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("swaps", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_swaps_operations;
+	proc_create("swaps", 0, NULL, &proc_swaps_operations);
 	return 0;
 }
 __initcall(procswaps_init);
-- 
1.5.3.rc5


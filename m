Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYDHLUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYDHLUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYDHLTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36051 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYDHLTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:20 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 8/29] proc: use non-racy method for /proc/page_owner creation
Date: Tue,  8 Apr 2008 15:19:15 +0400
Message-Id: <1207653576-12640-8-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 fs/proc/proc_misc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 0390844..fbaf067 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -1041,12 +1041,10 @@ void __init proc_misc_init(void)
 #ifdef CONFIG_PAGE_OWNER
 	{
 		struct proc_dir_entry *entry;
-		entry = create_proc_entry("page_owner",
-			S_IWUSR | S_IRUGO, NULL);
-		if (entry) {
-			entry->proc_fops = &proc_page_owner_operations;
+		entry = proc_create("page_owner",
+			S_IWUSR | S_IRUGO, NULL, &proc_page_owner_operations);
+		if (entry)
 			entry->size = 1024;
-		}
 	}
 #endif
 }
-- 
1.5.3.rc5


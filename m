Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYDHLW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYDHLW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYDHLT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:6736 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYDHLTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:22 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 19/29] cris: use non-racy method for /proc/system_profile creation
Date: Tue,  8 Apr 2008 15:19:26 +0400
Message-Id: <1207653576-12640-19-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/kernel/profile.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/kernel/profile.c b/arch/cris/kernel/profile.c
index aad0a9e..44f7b4f 100644
--- a/arch/cris/kernel/profile.c
+++ b/arch/cris/kernel/profile.c
@@ -75,9 +75,9 @@ __init init_cris_profile(void)
 
 	sample_buffer_pos = sample_buffer;
 
-	entry = create_proc_entry("system_profile", S_IWUSR | S_IRUGO, NULL);
+	entry = proc_create("system_profile", S_IWUSR | S_IRUGO, NULL,
+			    &cris_proc_profile_operations);
 	if (entry) {
-		entry->proc_fops = &cris_proc_profile_operations;
 		entry->size = SAMPLE_BUFFER_SIZE;
 	}
 	prof_running = 1;
-- 
1.5.3.rc5


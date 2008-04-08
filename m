Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYDHL2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYDHL2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYDHLTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9143 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYDHLTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:52 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 11/29] sound: use non-racy method for /proc/driver/snd-page-alloc creation
Date: Tue,  8 Apr 2008 15:19:18 +0400
Message-Id: <1207653576-12640-11-git-send-email-den@openvz.org>
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
 sound/core/memalloc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 920e578..23b7bc0 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -629,9 +629,8 @@ static const struct file_operations snd_mem_proc_fops = {
 static int __init snd_mem_init(void)
 {
 #ifdef CONFIG_PROC_FS
-	snd_mem_proc = create_proc_entry(SND_MEM_PROC_FILE, 0644, NULL);
-	if (snd_mem_proc)
-		snd_mem_proc->proc_fops = &snd_mem_proc_fops;
+	snd_mem_proc = proc_create(SND_MEM_PROC_FILE, 0644, NULL,
+				   &snd_mem_proc_fops);
 #endif
 	return 0;
 }
-- 
1.5.3.rc5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYDHLVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYDHLVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYDHLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3418 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYDHLTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:21 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 13/29] samples: use non-racy method for /proc/marker-example creation
Date: Tue,  8 Apr 2008 15:19:20 +0400
Message-Id: <1207653576-12640-13-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 samples/markers/marker-example.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/samples/markers/marker-example.c b/samples/markers/marker-example.c
index 05e438f..e90dc5d 100644
--- a/samples/markers/marker-example.c
+++ b/samples/markers/marker-example.c
@@ -33,10 +33,8 @@ static struct file_operations mark_ops = {
 static int example_init(void)
 {
 	printk(KERN_ALERT "example init\n");
-	pentry_example = create_proc_entry("marker-example", 0444, NULL);
-	if (pentry_example)
-		pentry_example->proc_fops = &mark_ops;
-	else
+	pentry_example = proc_create("marker-example", 0444, NULL, &mark_ops);
+	if (!pentry_example)
 		return -EPERM;
 	return 0;
 }
-- 
1.5.3.rc5


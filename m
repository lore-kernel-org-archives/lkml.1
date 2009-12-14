Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbZLNIYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbZLNIYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZLNIYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:24:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZLNIYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:24:07 -0500
Date: Mon, 14 Dec 2009 03:23:56 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Amerigo Wang <amwang@redhat.com>
Message-Id: <20091214082700.4224.57640.sendpatchset@localhost.localdomain>
Subject: [Patch] perf: use format string of printf to align strings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of filling whitespaces to do alignment, use
printf's format string.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 9f810b1..e427d69 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -286,8 +286,7 @@ void list_common_cmds_help(void)
 
 	puts(" The most commonly used perf commands are:");
 	for (i = 0; i < ARRAY_SIZE(common_cmds); i++) {
-		printf("   %s   ", common_cmds[i].name);
-		mput_char(' ', longest - strlen(common_cmds[i].name));
+		printf("   %-*s   ", longest, common_cmds[i].name);
 		puts(common_cmds[i].help);
 	}
 }

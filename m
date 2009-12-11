Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZLKPht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZLKPht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbZLKPhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:37:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:57553 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbZLKPh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:37:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/9] kgdb: Replace strstr() by strchr() for single-character needles
Date: Fri, 11 Dec 2009 09:36:12 -0600
Message-Id: <1260545777-8089-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:32.0957 (UTC) FILETIME=[B75E06D0:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Some versions of gcc replace calls to strstr() with single-character
"needle" string parameters by calls to strchr() behind our back.
This causes linking errors if strchr() is defined as an inline function
in <asm/string.h> (e.g. on m68k, which BTW doesn't have kgdb support).

Prevent this by explicitly calling strchr() instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 2ab0492..fcb6ec1 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -891,16 +891,16 @@ static void kgdbts_run_tests(void)
 	int nmi_sleep = 0;
 	int i;
 
-	ptr = strstr(config, "F");
+	ptr = strchr(config, 'F');
 	if (ptr)
 		fork_test = simple_strtol(ptr + 1, NULL, 10);
-	ptr = strstr(config, "S");
+	ptr = strchr(config, 'S');
 	if (ptr)
 		do_sys_open_test = simple_strtol(ptr + 1, NULL, 10);
-	ptr = strstr(config, "N");
+	ptr = strchr(config, 'N');
 	if (ptr)
 		nmi_sleep = simple_strtol(ptr+1, NULL, 10);
-	ptr = strstr(config, "I");
+	ptr = strchr(config, 'I');
 	if (ptr)
 		sstep_test = simple_strtol(ptr+1, NULL, 10);
 
-- 
1.6.4.rc1


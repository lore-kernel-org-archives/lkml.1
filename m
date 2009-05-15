Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZEOHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZEOHvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZEOHvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 03:51:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZEOHvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 03:51:41 -0400
Date: Fri, 15 May 2009 03:51:18 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>
Message-Id: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
Subject: [Patch] kbuild: fix a compile warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got this warning:

 HOSTCC  scripts/basic/fixdep
scripts/basic/fixdep.c: In function 'traps':
scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer will break strict-aliasing rules
scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer will break strict-aliasing rules

Patch below fixes it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org> 

---
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 8912c0f..72c1520 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -373,10 +373,11 @@ void print_deps(void)
 void traps(void)
 {
 	static char test[] __attribute__((aligned(sizeof(int)))) = "CONF";
+	int *p = (int *)test;
 
-	if (*(int *)test != INT_CONF) {
+	if (*p != INT_CONF) {
 		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianess? %#x\n",
-			*(int *)test);
+			*p);
 		exit(2);
 	}
 }

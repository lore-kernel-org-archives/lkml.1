Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYK1Hdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYK1Hdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 02:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYK1Hdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 02:33:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61949 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYK1Hdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:33:43 -0500
Message-ID: <492F9EF0.5010804@cn.fujitsu.com>
Date: Fri, 28 Nov 2008 15:34:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: cleanup for as/deadline/cfq_var_store()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/as-iosched.c       |    4 +---
 block/cfq-iosched.c      |    4 +---
 block/deadline-iosched.c |    4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 71f0abb..d122076 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1403,9 +1403,7 @@ as_var_show(unsigned int var, char *page)
 static ssize_t
 as_var_store(unsigned long *var, const char *page, size_t count)
 {
-	char *p = (char *) page;
-
-	*var = simple_strtoul(p, &p, 10);
+	*var = simple_strtoul(page, NULL, 10);
 	return count;
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..5185dd1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2281,9 +2281,7 @@ cfq_var_show(unsigned int var, char *page)
 static ssize_t
 cfq_var_store(unsigned int *var, const char *page, size_t count)
 {
-	char *p = (char *) page;
-
-	*var = simple_strtoul(p, &p, 10);
+	*var = simple_strtoul(page, NULL, 10);
 	return count;
 }
 
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index fd31117..5e24af5 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -380,9 +380,7 @@ deadline_var_show(int var, char *page)
 static ssize_t
 deadline_var_store(int *var, const char *page, size_t count)
 {
-	char *p = (char *) page;
-
-	*var = simple_strtol(p, &p, 10);
+	*var = simple_strtol(page, NULL, 10);
 	return count;
 }
 
-- 
1.5.4.rc3

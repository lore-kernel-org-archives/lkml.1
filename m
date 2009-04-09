Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZDIEhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZDIEhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZDIEhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:37:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:57085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbZDIEhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:37:32 -0400
Date: Thu, 9 Apr 2009 04:36:50 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DD694C.8020902@cn.fujitsu.com>
References: <49DD694C.8020902@cn.fujitsu.com>
Subject: [tip:tracing/urgent] blktrace: pass the right pointer to kfree()
Message-ID: <tip-9eb85125ce218a8b8d9a7c982510388e227adbec@git.kernel.org>
Git-Commit-ID: 9eb85125ce218a8b8d9a7c982510388e227adbec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 04:36:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9eb85125ce218a8b8d9a7c982510388e227adbec
Gitweb:     http://git.kernel.org/tip/9eb85125ce218a8b8d9a7c982510388e227adbec
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 9 Apr 2009 11:19:40 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 05:52:40 +0200

blktrace: pass the right pointer to kfree()

Impact: fix kfree crash with non-standard act_mask string

If passing a string with leading white spaces to strstrip(),
the returned ptr != the original ptr.

This bug was introduced by me.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <49DD694C.8020902@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b32ff44..921ef5d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1377,12 +1377,12 @@ static int blk_trace_str2mask(const char *str)
 {
 	int i;
 	int mask = 0;
-	char *s, *token;
+	char *buf, *s, *token;
 
-	s = kstrdup(str, GFP_KERNEL);
-	if (s == NULL)
+	buf = kstrdup(str, GFP_KERNEL);
+	if (buf == NULL)
 		return -ENOMEM;
-	s = strstrip(s);
+	s = strstrip(buf);
 
 	while (1) {
 		token = strsep(&s, ",");
@@ -1403,7 +1403,7 @@ static int blk_trace_str2mask(const char *str)
 			break;
 		}
 	}
-	kfree(s);
+	kfree(buf);
 
 	return mask;
 }

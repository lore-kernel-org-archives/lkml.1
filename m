Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZDIDTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZDIDTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZDIDTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:19:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757325AbZDIDTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:19:00 -0400
Message-ID: <49DD694C.8020902@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 11:19:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] blktrace: pass the right pointer to kfree()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If passing a string with leading white spaces to strstrip(),
the returned ptr != the original ptr.

This bug was introduced by me.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3

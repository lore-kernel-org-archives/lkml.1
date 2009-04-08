Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbZDHPHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbZDHPHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZDHPHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:07:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177AbZDHPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:07:14 -0400
Date: Wed, 8 Apr 2009 15:06:34 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49CC97B6.7040809@cn.fujitsu.com>
References: <49CC97B6.7040809@cn.fujitsu.com>
Subject: [tip:core/urgent] printk: fix wrong format string iter for printk
Message-ID: <tip-022624a758dc9489388a99ad29577b4c8c09237c@git.kernel.org>
Git-Commit-ID: 022624a758dc9489388a99ad29577b4c8c09237c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:06:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  022624a758dc9489388a99ad29577b4c8c09237c
Gitweb:     http://git.kernel.org/tip/022624a758dc9489388a99ad29577b4c8c09237c
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 17:09:10 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 17:03:44 +0200

printk: fix wrong format string iter for printk

printk("%Q");

 Output before patch:  %QQ
 Output  after patch:  %Q

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: torvalds@linux-foundation.org
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49CC97B6.7040809@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/vsprintf.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index be3001f..7536ace 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1051,13 +1051,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			if (str < end)
 				*str = '%';
 			++str;
-			if (*fmt) {
-				if (str < end)
-					*str = *fmt;
-				++str;
-			} else {
-				--fmt;
-			}
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
@@ -1339,8 +1332,6 @@ do {									\
 			break;
 
 		case FORMAT_TYPE_INVALID:
-			if (!*fmt)
-				--fmt;
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
@@ -1523,13 +1514,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			if (str < end)
 				*str = '%';
 			++str;
-			if (*fmt) {
-				if (str < end)
-					*str = *fmt;
-				++str;
-			} else {
-				--fmt;
-			}
 			break;
 
 		case FORMAT_TYPE_NRCHARS:

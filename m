Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYKVCZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYKVCZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYKVCZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:25:24 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:52019 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYKVCZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:25:24 -0500
Date: Fri, 21 Nov 2008 18:24:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Anton Altaparmakov <aia21@cantab.net>
Subject: [PATCH] ntfs: don't fool kernel-doc
Message-Id: <20081121182435.b665b565.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49276D65.010D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

kernel-doc handles macros now (it has for quite some time),
so change the ntfs_debug() macro's kernel-doc to be just before
the macro instead of before a phony function prototype.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Anton Altaparmakov <aia21@cantab.net>
---
 fs/ntfs/debug.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- linux-next-20081120.orig/fs/ntfs/debug.h
+++ linux-next-20081120/fs/ntfs/debug.h
@@ -30,7 +30,8 @@
 
 extern int debug_msgs;
 
-#if 0 /* Fool kernel-doc since it doesn't do macros yet */
+extern void __ntfs_debug (const char *file, int line, const char *function,
+	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
 /**
  * ntfs_debug - write a debug level message to syslog
  * @f:		a printf format string containing the message
@@ -39,11 +40,6 @@ extern int debug_msgs;
  * ntfs_debug() writes a DEBUG level message to the syslog but only if the
  * driver was compiled with -DDEBUG. Otherwise, the call turns into a NOP.
  */
-static void ntfs_debug(const char *f, ...);
-#endif
-
-extern void __ntfs_debug (const char *file, int line, const char *function,
-	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
 #define ntfs_debug(f, a...)						\
 	__ntfs_debug(__FILE__, __LINE__, __func__, f, ##a)
 

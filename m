Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYFHR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYFHR1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYFHR1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:27:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:17822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbYFHR1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xRS7qVOG3hISxt3JQGPgNloso8mIWFQGKmXXfbWazpsFgpaEj93boBZzNqHXEr9u2v
         8EBzUc3+M1faN7kJ+/k2AFCczr+Uq5akSZtds68EoA6GTGGUO6p+T2KH1vV12OEGt4Dy
         JhEliSS8JCZ2C/Ve5ExyUDLFD7SmeVH9bwaI8=
Message-ID: <b9df5fa10806081026n77f72b87he209a0f0dbf02653@mail.gmail.com>
Date: Sun, 8 Jun 2008 23:26:48 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Removes PID_MAX_DEFAULT
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes use of PID_MAX_DEFAULT. Couldn't find any specific
maintainer , so I send it here directly. [Note: I didn't use git.]

Signed-off-by: Md.Rakib Hassan Mullick (rakib.mullick@gmail.com)
---
diff -upr linux-2.6.25-vanilla/include/linux/threads.h
linux-2.6.25/include/linux/threads.h
--- linux-2.6.25-vanilla/include/linux/threads.h	2008-04-17
08:49:44.000000000 +0600
+++ linux-2.6.25/include/linux/threads.h	2008-06-07 18:46:29.000000000 +0600
@@ -22,15 +22,10 @@
 #define MIN_THREADS_LEFT_FOR_ROOT 4

 /*
- * This controls the default maximum pid allocated to a process
- */
-#define PID_MAX_DEFAULT (CONFIG_BASE_SMALL ? 0x1000 : 0x8000)
-
-/*
  * A maximum of 4 million PIDs should be enough for a while.
  * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see futex.h.]
  */
 #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
-	(sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
+	(sizeof(long) > 4 ? 4 * 1024 * 1024 : (CONFIG_BASE_SMALL ? 0x1000 : 0x8000)))

 #endif
Only in linux-2.6.25/include/linux: threads.h~
diff -upr linux-2.6.25-vanilla/kernel/pid.c linux-2.6.25/kernel/pid.c
--- linux-2.6.25-vanilla/kernel/pid.c	2008-04-17 08:49:44.000000000 +0600
+++ linux-2.6.25/kernel/pid.c	2008-06-07 18:46:25.000000000 +0600
@@ -42,7 +42,10 @@ static struct hlist_head *pid_hash;
 static int pidhash_shift;
 struct pid init_struct_pid = INIT_STRUCT_PID;

-int pid_max = PID_MAX_DEFAULT;
+/*
+ * This controls the default maximum pid allocated to a process
+ */
+int pid_max = CONFIG_BASE_SMALL ? 0x1000 : 0x8000 ;

 #define RESERVED_PIDS		300

Only in linux-2.6.25/kernel: pid.c~

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYFJHup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYFJHup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYFJHub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:50:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:40749 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYFJHua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=M8YxquCNS1hoT3H/rQJy7lRMKh056tM8C4aQE08VBVzziF2NxOYaw4LjXDCd1d7sVg
         sQO/Fh/p2gsSyG0Blgx+jOgp6S4ql5D1JIXyKHk0hMzpEiBmDcIe4WyIsECoKYLfMj9y
         KnCcnRKyo2jnkYeN9LvDT9vxUCBw4wJvvimMk=
Message-ID: <b9df5fa10806100050j684db890wc48ef0596ee95719@mail.gmail.com>
Date: Tue, 10 Jun 2008 13:50:26 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: mingo@elte.hu
Subject: [PATCH] resend Removes PID_MAX_DEFAULT.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes use of PID_MAX_DEFAULT. please reply.

Signed-off-by: Md. Rakib Hassan Mullick (rakib.mullick@gmail.com)
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbYFRK5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbYFRK5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYFRK5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:57:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:60337 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYFRK5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=yBxPyl8uVDPy8aXU0dnpG0sOCa2QI1ziiOCKA0lAChFDA956m0qnnJHF1s7xyLh/Kx
         /fBrEkcZauv5l4Y8XSIbkubkxjSqtdOQQgjPLRb/S6dMRvk4oVz5GTaUXnIizEBQSYtc
         WMUqvtlhLGeoYB1A9Jro6EyoA+i4NVeFAosrg=
Message-ID: <b9df5fa10806180357x7c950077wb87b9fca0ee48@mail.gmail.com>
Date: Wed, 18 Jun 2008 16:57:18 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: mingo@redhat.com, arjan@infradead.org
Subject: [PATCH]include/linux/threads.h : Removes extra checking CONFIG_BASE_SMALL
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In existing code for defining PID_MAX_DEFAULT and PID_MAX_LIMIT,a check for
CONFIG_BASE_SMALL has been made twice. This patch reduces an extra checking.


Signed-off-by: Md.Rakib H. Mullick ( rakib.mullick@gmail.com)

--- linux-2.6.25/include/linux/threads.h.orig	2008-06-16
11:46:42.000000000 +0600
+++ linux-2.6.25/include/linux/threads.h	2008-06-17 19:41:19.462424632 +0600
@@ -24,13 +24,17 @@
 /*
  * This controls the default maximum pid allocated to a process
  */
-#define PID_MAX_DEFAULT (CONFIG_BASE_SMALL ? 0x1000 : 0x8000)
-
 /*
  * A maximum of 4 million PIDs should be enough for a while.
  * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see futex.h.]
  */
-#define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
-	(sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
+#if (CONFIG_BASE_SMALL)
+#define PID_MAX_DEFAULT 	0x1000
+#define PID_MAX_LIMIT 		(PAGE_SIZE * 8)
+#else
+#define PID_MAX_DEFAULT        	0x8000
+#define PID_MAX_LIMIT (sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT)
+#endif
+

 #endif

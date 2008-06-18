Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYFRKSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYFRKSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYFRKR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:17:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13582 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYFRKR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TxB1LR+1xENKsHtVFHoaVfrf4KWdiaNYyqbQlkEEOPgRBWUxraZ2Jb40hghOlCWQ+f
         OEciSWCVNfm7dTu1E2UReOJFPKVTgDW7+DUXGx28MhTvJFFuxrc1aQZzAut5ts5yIlij
         Ui3LjqpuoNft5hjAkxWJxjgywFXTmSBi8KsvM=
Message-ID: <b9df5fa10806180317k35e9861dr37bc346062924299@mail.gmail.com>
Date: Wed, 18 Jun 2008 16:17:56 +0600
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

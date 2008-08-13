Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYHMUqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYHMUqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYHMUqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:46:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35251 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYHMUqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:46:37 -0400
Date: Wed, 13 Aug 2008 23:44:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.27 patch] #error for gcc 4.1.{0,1}
Message-ID: <20080813204445.GA7071@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.1.0 and 4.1.1 are known to miscompile the kernel:
  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781

Usage of weak functions has become a common pattern in the kernel, and 
usages get added in each kernel version increasing the probability of 
bugs with each kernel release.

This miscompilation of weak functions can result in subtle runtime 
errors.

#error for gcc 4.1.0 and 4.1.1 to prevent users from running into
this bug.

Note:
We already printed a #warning for gcc 4.1.0 due to a different bug.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 6 Aug 2008
- 26 Jun 2008

ee78871a1d85fe60958748c208389adb4031fefe diff --git a/init/main.c b/init/main.c
index f7fb200..bede344 100644
--- a/init/main.c
+++ b/init/main.c
@@ -76,8 +76,9 @@
  * trouble.
  */
 
-#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ == 0
-#warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
+/*  due to http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781  */
+#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && (__GNUC_PATCHLEVEL__ == 0 || __GNUC_PATCHLEVEL__ == 1)
+#error gcc 4.1.0 and 4.1.1 are known to miscompile the kernel.
 #endif
 
 static int kernel_init(void *);



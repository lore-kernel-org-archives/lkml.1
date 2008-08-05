Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYHEWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYHEWbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbYHEWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:31:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42560 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbYHEWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:31:09 -0400
Date: Wed, 6 Aug 2008 01:29:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #error for gcc 4.1.{0,1}
Message-ID: <20080805222944.GB6477@cs181140183.pp.htv.fi>
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

If anyone has a better patch please step forward - otherwise I'm
proposing this patch.

This patch has been sent on:
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



Return-Path: <linux-kernel-owner+w=401wt.eu-S1761802AbXENJVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802AbXENJVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbXENJVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:21:48 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:50870 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbXENJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:21:47 -0400
Date: Mon, 14 May 2007 11:21:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [patch] simplify compat_sys_timerfd.
Message-ID: <20070514092106.GA8968@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Just thought this is easier to read.

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Feel free to ignore/drop.

 fs/compat.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux-2.6/fs/compat.c
===================================================================
--- linux-2.6.orig/fs/compat.c
+++ linux-2.6/fs/compat.c
@@ -2230,21 +2230,16 @@ asmlinkage long compat_sys_signalfd(int 
 asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
 				   const struct compat_itimerspec __user *utmr)
 {
-	long res;
 	struct itimerspec t;
 	struct itimerspec __user *ut;
 
-	res = -EFAULT;
 	if (get_compat_itimerspec(&t, utmr))
-		goto err_exit;
+		return -EFAULT;
 	ut = compat_alloc_user_space(sizeof(*ut));
-	if (copy_to_user(ut, &t, sizeof(t)) )
-		goto err_exit;
+	if (copy_to_user(ut, &t, sizeof(t)))
+		return -EFAULT;
 
-	res = sys_timerfd(ufd, clockid, flags, ut);
-err_exit:
-	return res;
+	return sys_timerfd(ufd, clockid, flags, ut);
 }
 
 #endif /* CONFIG_TIMERFD */
-

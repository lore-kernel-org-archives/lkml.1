Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYIPBEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYIPBEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 21:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYIPBEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 21:04:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:37691 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYIPBEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 21:04:04 -0400
Message-ID: <48CF061A.5060002@ct.jp.nec.com>
Date: Mon, 15 Sep 2008 18:04:26 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] uaccess: fix parameters inversion for __copy_from_user_inatomic()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The following patch changes to use __copy_from_user_inatomic(),
but the passing parameters incorrect.

    x86: some lock annotations for user copy paths, v3

    - add annotation back to clear_user()
    - change probe_kernel_address() to _inatomic*() method

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/uaccess.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 2062293..6b58367 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -78,7 +78,7 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 							\
 		set_fs(KERNEL_DS);			\
 		pagefault_disable();			\
-		ret = __copy_from_user_inatomic((__force typeof(retval) __user *)(addr), &(retval), sizeof(retval));		\
+		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
 		pagefault_enable();			\
 		set_fs(old_fs);				\
 		ret;					\
-- 
1.5.6


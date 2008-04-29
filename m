Return-Path: <linux-kernel-owner+w=401wt.eu-S1765982AbYD2OVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765982AbYD2OVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbYD2OQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:16:19 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52879 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbYD2OP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:15:56 -0400
Message-Id: <20080429140251.004942050@de.ibm.com>
References: <20080429140117.631962807@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Apr 2008 16:01:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/15] uaccess_mvcos: #ifdef config dependent code.
Content-Disposition: inline; filename=010-uaccess-warning.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

arch/s390/lib/uaccess_mvcos.c:166:
 warning: 'strnlen_user_mvcos' defined but not used
arch/s390/lib/uaccess_mvcos.c:186:
 warning: 'strncpy_from_user_mvcos' defined but not used

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/lib/uaccess_mvcos.c |    2 ++
 1 file changed, 2 insertions(+)

Index: quilt-2.6/arch/s390/lib/uaccess_mvcos.c
===================================================================
--- quilt-2.6.orig/arch/s390/lib/uaccess_mvcos.c
+++ quilt-2.6/arch/s390/lib/uaccess_mvcos.c
@@ -162,6 +162,7 @@ static size_t clear_user_mvcos(size_t si
 	return size;
 }
 
+#ifdef CONFIG_S390_SWITCH_AMODE
 static size_t strnlen_user_mvcos(size_t count, const char __user *src)
 {
 	char buf[256];
@@ -199,6 +200,7 @@ static size_t strncpy_from_user_mvcos(si
 	} while ((len_str == len) && (done < count));
 	return done;
 }
+#endif /* CONFIG_S390_SWITCH_AMODE */
 
 struct uaccess_ops uaccess_mvcos = {
 	.copy_from_user = copy_from_user_mvcos_check,

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


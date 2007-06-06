Return-Path: <linux-kernel-owner+w=401wt.eu-S934270AbXFFEpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270AbXFFEpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbXFFEpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:45:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62558 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXFFEo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:44:59 -0400
Date: Tue, 5 Jun 2007 21:43:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: ak@suse.de, akpm <akpm@linux-foundation.org>
Subject: [PATCH] x86_64: use NULL for pointer
Message-Id: <20070605214326.5a108568.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointer:
arch/x86_64/kernel/vsyscall.c:183:21: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86_64/kernel/vsyscall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc3-git7.orig/arch/x86_64/kernel/vsyscall.c
+++ linux-2.6.22-rc3-git7/arch/x86_64/kernel/vsyscall.c
@@ -180,7 +180,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
 
-	vgettimeofday(&tv, 0);
+	vgettimeofday(&tv, NULL);
 	result = tv.tv_sec;
 	if (t)
 		*t = result;

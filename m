Return-Path: <linux-kernel-owner+w=401wt.eu-S932688AbYCEL7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbYCEL7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765531AbYCEL53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:57:29 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:16555 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763451AbYCEL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:57:21 -0500
Message-Id: <20080305115715.207905001@de.ibm.com>
References: <20080305115432.691030908@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 12:54:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Hongjie Yang <hongjie@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/10] incorrect reipl nss name.
Content-Disposition: inline; filename=010-nssname.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongjie Yang <hongjie@us.ibm.com>

/sys/firmware/reipl/nss/name contains the nss name when defsys or
savesys command has been executed. If the defsys or savesys command
fails the kernel_nss_name has to be cleared since a reipl on that
nss name won't be possible.

Signed-off-by: Hongjie Yang <hongjie@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/early.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/early.c
+++ quilt-2.6/arch/s390/kernel/early.c
@@ -88,13 +88,17 @@ static noinline __init void create_kerne
 
 	__cpcmd(defsys_cmd, NULL, 0, &response);
 
-	if (response != 0)
+	if (response != 0) {
+		kernel_nss_name[0] = '\0';
 		return;
+	}
 
 	__cpcmd(savesys_cmd, NULL, 0, &response);
 
-	if (response != strlen(savesys_cmd))
+	if (response != strlen(savesys_cmd)) {
+		kernel_nss_name[0] = '\0';
 		return;
+	}
 
 	ipl_flags = IPL_NSS_VALID;
 }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


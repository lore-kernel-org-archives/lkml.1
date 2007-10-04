Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbXJDLgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbXJDLgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXJDL3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:29:07 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:57487 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbXJDL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:30 -0400
Message-Id: <20071004112832.537008311@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 28/34] Use IPL CLEAR for reipl under z/VM
Content-Disposition: inline; filename=028-ipl-clear.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

If we use the CLEAR ipl option, reipl is faster, since then VM can release
the memory, which has been paged out.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/ipl.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/ipl.c
+++ quilt-2.6/arch/s390/kernel/ipl.c
@@ -735,10 +735,10 @@ void do_reipl(void)
 	case REIPL_METHOD_CCW_VM:
 		reipl_get_ascii_loadparm(loadparm);
 		if (strlen(loadparm) == 0)
-			sprintf(buf, "IPL %X",
+			sprintf(buf, "IPL %X CLEAR",
 				reipl_block_ccw->ipl_info.ccw.devno);
 		else
-			sprintf(buf, "IPL %X LOADPARM '%s'",
+			sprintf(buf, "IPL %X CLEAR LOADPARM '%s'",
 				reipl_block_ccw->ipl_info.ccw.devno, loadparm);
 		__cpcmd(buf, NULL, 0, NULL);
 		break;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


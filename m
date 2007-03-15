Return-Path: <linux-kernel-owner+w=401wt.eu-S1161218AbXCONto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161218AbXCONto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933569AbXCONto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:49:44 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:59907 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564AbXCONtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:49:43 -0400
Date: Thu, 15 Mar 2007 19:19:21 +0530
To: Linux Memory Management <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] oom fix: prevent oom from killing a process with children/sibling unkillable
Message-ID: <20070315134921.GD18033@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: ankita@in.ibm.com (Ankita Garg)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Looking at oom_kill.c, found that the intention to not kill the selected
process if any of its children/siblings has OOM_DISABLE set, is not being met.


Signed-off-by: Ankita Garg <ankita@in.ibm.com>

Index: ankita/linux-2.6.20.1/mm/oom_kill.c
===================================================================
--- ankita.orig/linux-2.6.20.1/mm/oom_kill.c	2007-02-20 12:04:32.000000000 +0530
+++ ankita/linux-2.6.20.1/mm/oom_kill.c	2007-03-15 12:44:50.000000000 +0530
@@ -320,7 +320,7 @@
 	 * Don't kill the process if any threads are set to OOM_DISABLE
 	 */
 	do_each_thread(g, q) {
-		if (q->mm == mm && p->oomkilladj == OOM_DISABLE)
+		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
 			return 1;
 	} while_each_thread(g, q);
 

Regards,
-- 
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   

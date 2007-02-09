Return-Path: <linux-kernel-owner+w=401wt.eu-S1946637AbXBIQjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946637AbXBIQjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946647AbXBIQjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51691 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946637AbXBIQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:56 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] in non-NUMA case mark GFP_THISNODE gfp_t
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlz-0006nL-NJ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... operations with it are OK as is, but flags & ~0 will have no idea that
this ~0 is meant to be ~gfp_t.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/gfp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 00c314a..063799e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -70,7 +70,7 @@ struct vm_area_struct;
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
 #else
-#define GFP_THISNODE	0
+#define GFP_THISNODE	((__force gfp_t)0)
 #endif
 
 
-- 
1.5.0-rc2.GIT



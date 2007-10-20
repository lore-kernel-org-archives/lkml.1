Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbXJUDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbXJUDQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 23:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbXJUDPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 23:15:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56887 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbXJUDPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 23:15:36 -0400
Date: Sat, 20 Oct 2007 21:45:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] oom_kill bug
Message-ID: <20071020204532.GS8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Wrong order of arguments

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 824cade..91a081a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -496,7 +496,7 @@ retry:
 			panic("Out of memory and no killable processes...\n");
 		}
 
-		if (oom_kill_process(p, points, gfp_mask, order,
+		if (oom_kill_process(p, gfp_mask, order, points,
 				     "Out of memory"))
 			goto retry;
 

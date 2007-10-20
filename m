Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXJUBy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXJUBy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbXJUBwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:52:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:22290 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXJUBwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:52:36 -0400
Date: Sun, 21 Oct 2007 02:00:12 +0400
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix oom_kill_process() printout
Message-ID: <20071020220012.GA1825@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CHECK   mm/oom_kill.c
mm/oom_kill.c:499:27: warning: incorrect type in argument 2 (different base types)
mm/oom_kill.c:499:27:    expected restricted unsigned int [usertype] gfp_mask
mm/oom_kill.c:499:27:    got unsigned long [unsigned] [addressable] points
mm/oom_kill.c:499:35: warning: incorrect type in argument 3 (different base types)
mm/oom_kill.c:499:35:    expected int [signed] order
mm/oom_kill.c:499:35:    got restricted unsigned int [usertype] gfp_mask

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -496,7 +496,7 @@ retry:
 			panic("Out of memory and no killable processes...\n");
 		}
 
-		if (oom_kill_process(p, points, gfp_mask, order,
+		if (oom_kill_process(p, gfp_mask, order, points,
 				     "Out of memory"))
 			goto retry;
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbXBWXLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbXBWXLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXBWXLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:11:51 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:17377 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXBWXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:11:50 -0500
Date: Fri, 23 Feb 2007 15:11:12 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] mm/mincore: Return EFAULT when passed an invalid address.
Message-ID: <20070223231112.GM7920@ca-server1.us.oracle.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20070223225847.GL7920@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223225847.GL7920@ca-server1.us.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 	The locking fix to sys_mincore in commit
2f77d107050abc14bc393b34bdb7b91cf670c250 returns -ENOMEM when given a
bad userspace address.  It should return -EFAULT.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

diff --git a/mm/mincore.c b/mm/mincore.c
index 8aca6f7..4af963c 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -122,7 +122,7 @@ asmlinkage long sys_mincore(unsigned long start, size_t len,
 
 	/* ..and we need to be passed a valid user-space range */
 	if (!access_ok(VERIFY_READ, (void __user *) start, len))
-		return -ENOMEM;
+		return -EFAULT;
 
 	/* This also avoids any overflows on PAGE_CACHE_ALIGN */
 	pages = len >> PAGE_SHIFT;


-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

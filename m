Return-Path: <linux-kernel-owner+w=401wt.eu-S1031654AbXEAKHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031654AbXEAKHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031653AbXEAKHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:07:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031648AbXEAKHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:07:32 -0400
Subject: [GFS2] Fix a bug on i386 due to evaluation order [6/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:02:55 +0100
Message-Id: <1178013775.5462.138.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 420d2a1028b906f24e836e37089a6ad55ab1848f Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Sun, 18 Mar 2007 16:05:27 +0000
Subject: [PATCH] [GFS2] Fix a bug on i386 due to evaluation order

Since gcc didn't evaluate the last two terms of the expression in
glock.c:1881 as a constant expression, it resulted in an error on
i386 due to the lack of a 64bit divide instruction. This adds some
brackets to fix the problem.

This was reported by Andrew Morton.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e707594..b8aa816 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1880,7 +1880,7 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 	if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
 		print_dbg(gi, "  Demotion req to state %u (%llu uS ago)\n",
 			  gl->gl_demote_state,
-			  (u64)(jiffies - gl->gl_demote_time)*1000000/HZ);
+			  (u64)(jiffies - gl->gl_demote_time)*(1000000/HZ));
 	}
 	if (gl->gl_ops == &gfs2_inode_glops && gl->gl_object) {
 		if (!test_bit(GLF_LOCK, &gl->gl_flags) &&
-- 
1.5.1.2




Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZEIRrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZEIRrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZEIRrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:47:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53288 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZEIRrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:47:46 -0400
Subject: GFS2: Pull request (fix)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Sat, 09 May 2009 18:49:07 +0100
Message-Id: <1241891347.3350.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patch,

Steve.

---------------------------------------------------------------------------
The following changes since commit 091bf7624d1c90cec9e578a18529f615213ff847:
  Linus Torvalds (1):
        Linux 2.6.30-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (1):
      GFS2: Fix glock ref counting bug

 fs/gfs2/glock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

----------------------------------------------------------------------
>From 0c7a531a200480c7bc447260376973d830da9069 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 30 Apr 2009 14:52:58 +0100
Subject: [PATCH] GFS2: Fix glock ref counting bug

Depending on the ordering of events as we go around the
glock shrinker loop, it is possible to drop the ref count
of a glock incorrectly. It doesn't happen very often. This
patch corrects the got_ref variable, fixing the problem.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1afd9f2..ff49810 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1304,6 +1304,7 @@ static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 				nr--;
 				if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 					gfs2_glock_put(gl);
+				got_ref = 0;
 			}
 			spin_lock(&lru_lock);
 			if (may_demote)
-- 
1.6.0.6




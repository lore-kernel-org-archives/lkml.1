Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYHYVtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYHYVtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYHYVtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:49:24 -0400
Received: from flusers.ccur.com ([12.192.68.2]:41199 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751788AbYHYVtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:49:23 -0400
X-Greylist: delayed 2010 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2008 17:49:22 EDT
Date: Mon, 25 Aug 2008 17:16:23 -0400
From: Joe Korty <joe.korty@ccur.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lockstat - repair erronous contention statistics
Message-ID: <20080825211623.GA27969@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bad contention counting in /proc/lock_stat.

/proc/lockstat tries to gather per-ip contention
statistics per-lock.  This was failing due to
a garbage per-ip index selector being used.

Index: 2.6.26/kernel/lockdep.c
===================================================================
--- 2.6.26.orig/kernel/lockdep.c	2008-07-13 17:51:29.000000000 -0400
+++ 2.6.26/kernel/lockdep.c	2008-08-25 17:00:15.000000000 -0400
@@ -2791,7 +2791,7 @@
 
 	stats = get_lock_stats(hlock->class);
 	if (point < ARRAY_SIZE(stats->contention_point))
-		stats->contention_point[i]++;
+		stats->contention_point[point]++;
 	if (lock->cpu != smp_processor_id())
 		stats->bounces[bounce_contended + !!hlock->read]++;
 	put_lock_stats(stats);

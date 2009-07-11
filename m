Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZGKGwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZGKGwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 02:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZGKGwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 02:52:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZGKGwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 02:52:08 -0400
Date: Sat, 11 Jul 2009 08:51:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: -tip: block, mm: Fix build error in mm/memcontrol.c
Message-ID: <20090711065152.GA23336@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today's upstream tree build (x86, 64-bit, allyesconfig) failed with 
this build error:

    mm/memcontrol.c: In function ‘mem_cgroup_force_empty’:
    mm/memcontrol.c:1976: error: ‘BLK_RW_ASYNC’ undeclared (first use in this function)
    mm/memcontrol.c:1976: error: (Each undeclared identifier is reported only once
    mm/memcontrol.c:1976: error: for each function it appears in.)

Due to commit:

  8aa7e84: Fix congestion_wait() sync/async vs read/write confusion

Missing to include a required header file for the BLK_RW_ASYNC.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/memcontrol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2fa20d..708103d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -25,6 +25,7 @@
 #include <linux/smp.h>
 #include <linux/page-flags.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/limits.h>

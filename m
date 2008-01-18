Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbYARCiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbYARCiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760589AbYARCgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:36:54 -0500
Received: from waste.org ([66.93.16.53]:40567 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760444AbYARCgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:36:53 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 12] random: reuse rand_initialize
X-Mercurial-Node: 3e0b0226df90e95204a8fb4d016d58552f02f40a
Message-Id: <3e0b0226df90e95204a8.1200623626@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:46 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 6f8bed9c59f7 -r 3e0b0226df90 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -900,7 +900,7 @@
 			  sizeof(*(utsname()))/4);
 }
 
-static int __init rand_initialize(void)
+static int rand_initialize(void)
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
@@ -1102,9 +1102,7 @@
 		/* Clear the entropy pool counters. */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		init_std_data(&input_pool);
-		init_std_data(&blocking_pool);
-		init_std_data(&nonblocking_pool);
+		rand_initialize();
 		return 0;
 	default:
 		return -EINVAL;

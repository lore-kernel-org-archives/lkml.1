Return-Path: <linux-kernel-owner+w=401wt.eu-S1161226AbXBUNeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161226AbXBUNeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161230AbXBUNeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:34:46 -0500
Received: from gretel.pobox.com ([208.58.1.197]:36852 "EHLO gretel.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161226AbXBUNeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:34:46 -0500
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 08:34:45 EST
Date: Wed, 21 Feb 2007 18:36:00 +0530
From: Joshua N Pritikin <jpritikin@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] allow oom_adj of saintly processes
Message-ID: <20070221130600.GD7322@always.joy.eth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Key: 06E3 3D22 D307 AAE6 ACB4  6B44 A9CA A794 A4A6 0BBD
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the badness of a process is zero then oom_adj>0 has no effect. This 
patch makes sure that the oom_adj shift actually increases badness 
points appropriately.

I am not subscribed. Please CC me with any comments. Thanks.

Signed-off-by: Joshua N. Pritikin <jpritikin@pobox.com>

--- linux/mm/oom_kill.c.orig	2007-02-18 14:58:35.000000000 +0530
+++ linux/mm/oom_kill.c	2007-02-18 14:57:52.000000000 +0530
@@ -147,9 +147,11 @@ unsigned long badness(struct task_struct
 	 * Adjust the score by oomkilladj.
 	 */
 	if (p->oomkilladj) {
-		if (p->oomkilladj > 0)
+		if (p->oomkilladj > 0) {
+			if (!points)
+				points = 1;
 			points <<= p->oomkilladj;
-		else
+		} else
 			points >>= -(p->oomkilladj);
 	}
 

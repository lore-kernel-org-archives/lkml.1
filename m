Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYD2JhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYD2JhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYD2Jg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:36:57 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:45536 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYD2Jg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:36:57 -0400
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 05:36:56 EDT
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Tue, 29 Apr 2008 10:08:59 +0100
From: David Simner <djs203@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [patch] sched_info_switch not being called according to
	documentation (10545)
Message-ID: <20080429090859.GA16568@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

http://bugzilla.kernel.org/show_bug.cgi?id=10545

sched_stats.h says that __sched_info_switch is "called when prev !=
next" in the comment.  sched.c should therefore do that, see the patch
below:

David

--- linux-2.6.25-old/kernel/sched.c	2008-04-17 03:49:44.000000000 +0100
+++ linux-2.6.25/kernel/sched.c	2008-04-29 10:54:11.000000000 +0100
@@ -3944,9 +3944,9 @@
 	prev->sched_class->put_prev_task(rq, prev);
 	next = pick_next_task(rq, prev);
 
-	sched_info_switch(prev, next);
-
 	if (likely(prev != next)) {
+		sched_info_switch(prev, next);
+
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;

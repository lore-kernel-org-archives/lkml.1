Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZIPG0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZIPG0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZIPG0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:26:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33114 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZIPG0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:26:45 -0400
Date: Wed, 16 Sep 2009 15:26:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Limit blk_iopoll sysctl to CONFIG_BLOCK=y.
Message-ID: <20090916062627.GB5805@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_iopoll_enabled is defined in block/blk-iopoll.c, which is only built
in the CONFIG_BLOCK=y case. Make the sysctl depend on this, too.

Fixes up the CONFIG_BLOCK=n build.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 kernel/sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6bb59f7..1a631ba 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -91,7 +91,9 @@ extern int sysctl_nr_trim_pages;
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
+#ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
+#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_DETECT_SOFTLOCKUP
@@ -998,6 +1000,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_BLOCK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "blk_iopoll",
@@ -1006,6 +1009,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt

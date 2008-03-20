Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYCTNET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYCTNET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 09:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYCTNEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 09:04:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:48800 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYCTNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 09:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dmJ1IMNvQVnt6sMx4Q6FjwqMu/EuFBksqxozBZ0mGulqpXbUcYSRxGoNiHqg1wZsdVc6RJ847zb1OXfJNqcS6S4LBTlmsFK6zaimIPkkYldUoMFUrsrcdsbydjHA3xURSbffJ1dx/oL2OdUqyTyH7v5/blVdjssB1tVxXJGB8bg=
From: Denis Cheng <crquan@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] mark /proc/sys/dev/scsi/logging_level to be removed
Date: Thu, 20 Mar 2008 21:03:10 +0800
Message-Id: <1206018190-5888-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
Since scsi_logging_level module_param can be read/written while system
running, the demand for /proc/sys/dev/scsi/logging_level has been no longer
mandotory.

But someone might have already set this value in /etc/sysctl.conf, so
mark it to be removed in one year (until March 2009).

One year might be not enough or too long, this period should also be discussed.

 Documentation/feature-removal-schedule.txt |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c1d1fd0..97bdb96 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -328,3 +328,16 @@ Why:	Not used in-tree. The current out-of-tree users used it to
 	code / infrastructure should be in the kernel and not in some
 	out-of-tree driver.
 Who:	Thomas Gleixner <tglx@linutronix.de>
+
+---------------------------
+
+What:	/proc/sys/dev/scsi/logging_level
+When:	March 2009
+Files:	drivers/scsi/scsi_sysctl.c
+Check:	/etc/sysctl.conf
+Why:	its functionality is also provided by the scsi_mod's module param,
+	module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
+	that can be read and written with
+	/sys/module/scsi_mod/parameters/scsi_logging_level
+	like the sysctl interface while system running.
+Who:	Denis Cheng <crquan@gmail.com> or linux-scsi@vger.kernel.org
-- 
1.5.4.4


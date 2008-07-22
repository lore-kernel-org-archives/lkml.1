Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbYGVFdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbYGVFdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbYGVFX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:53879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480AbYGVFXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/79] block: make /proc/diskstats only build if CONFIG_PROC_FS is enabled
Date: Mon, 21 Jul 2008 22:19:00 -0700
Message-Id: <1216703983-21448-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

These functions are only needed if CONFIG_PROC_FS is enabled, so save
the space when it is not.

This also makes it easier for a patch later in this series to work
properly if CONFIG_PROC_FS is not enabled.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e8c42bf..68a5f28 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -544,6 +544,7 @@ static struct device_type disk_type = {
 	.release	= disk_release,
 };
 
+#ifdef CONFIG_PROC_FS
 /*
  * aggregate disk stat collector.  Uses the same stats that the sysfs
  * entries do, above, but makes them available through one seq_file.
@@ -653,6 +654,7 @@ const struct seq_operations diskstats_op = {
 	.stop	= diskstats_stop,
 	.show	= diskstats_show
 };
+#endif /* CONFIG_PROC_FS */
 
 static void media_change_notify_thread(struct work_struct *work)
 {
-- 
1.5.6.3


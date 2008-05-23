Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYEWQpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYEWQpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYEWQpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:45:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44040 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYEWQpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:45:02 -0400
Date: Fri, 23 May 2008 09:44:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: jens.axboe@oracle.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] block: genhd errors when CONFIG_PROC_FS=n
Message-Id: <20080523094411.06f173e0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

block/genhd.c has build errors when CONFIG_PROC_FS=n, so omit some of
its functions in that case.

/local/linsrc/linux-next-20080523/block/genhd.c: In function 'diskstats_start':
/local/linsrc/linux-next-20080523/block/genhd.c:555: error: 'find_start' undeclared (first use in this function)
/local/linsrc/linux-next-20080523/block/genhd.c:555: error: (Each undeclared identifier is reported only once
/local/linsrc/linux-next-20080523/block/genhd.c:555: error: for each function it appears in.)
make[2]: *** [block/genhd.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/genhd.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20080523.orig/block/genhd.c
+++ linux-next-20080523/block/genhd.c
@@ -539,6 +539,7 @@ static struct device_type disk_type = {
 	.release	= disk_release,
 };
 
+#ifdef CONFIG_PROC_FS
 /*
  * aggregate disk stat collector.  Uses the same stats that the sysfs
  * entries do, above, but makes them available through one seq_file.
@@ -644,6 +645,7 @@ const struct seq_operations diskstats_op
 	.stop	= diskstats_stop,
 	.show	= diskstats_show
 };
+#endif /* CONFIG_PROC_FS */
 
 static void media_change_notify_thread(struct work_struct *work)
 {

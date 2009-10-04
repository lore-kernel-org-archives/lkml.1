Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbZJDWoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbZJDWoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139AbZJDWoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:44:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9133 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbZJDWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:44:17 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5761"; a="24555581"
Message-ID: <a751bdc6978478de6d10440e587a2cc7.squirrel@www.codeaurora.org>
Date: Sun, 4 Oct 2009 15:49:34 -0700 (PDT)
Subject: [RFC] [PATCH 1/1] Remove static debugfs path from parse-events
From: ashwinc@codeaurora.org
To: mingo@redhat.com, "LKML" <linux-kernel@vger.kernel.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20091004154934_63351"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20091004154934_63351
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit


I was working on getting timechart running and noticed that it wouldn't
get any sched_switch/wakeup etc events if debugfs is mounted anywhere
other than /sys/kernel/debug/. Mine was mounted in /debug (the second
sane location ;) )

So we'd need something like whats in the patch to make use of the global
debugfs_path.

Also, I'm assuming that parse-events.c is governed by GPLv2 or something
similar ?

Cheers,
Ashwin


------=_20091004154934_63351
Content-Type: text/x-patch;
      name="perf-events-Remove-static-debugfs-path.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
      filename="perf-events-Remove-static-debugfs-path.patch"

>From 289657eaae162b6a5571894ec71d1ecca5454a54 Mon Sep 17 00:00:00 2001
From: Ashwin Chaugule <ashwinc@quicinc.com>
Date: Wed, 30 Sep 2009 13:36:58 -0400
Subject: [PATCH] 	[perf-events] Remove static debugfs path

	Timechart doesn't work if debugfs is not in /sys/kernel/debug/.
	Fixed by using global debugfs_path which is filled in by perf.

	modified:   tools/perf/util/parse-events.c

	Signed-off-by: Ashwin Chaugule <ashwinc@quicinc.com>
---
 tools/perf/util/parse-events.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 87c424d..c661c90 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -690,8 +690,11 @@ static void store_event_type(const char *orgname)
 	char filename[PATH_MAX], *c;
 	FILE *file;
 	int id;
+	
+	sprintf(filename, "%s/", debugfs_path);
+	strncat(filename, orgname, strlen(orgname));
+	strcat(filename, "/id");
 
-	sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);
 	c = strchr(filename, ':');
 	if (c)
 		*c = '/';
-- 
1.5.6.3

------=_20091004154934_63351--



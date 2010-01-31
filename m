Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196Ab0AaUCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0AaUCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157Ab0AaUCZ
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:02:25 -0500
Received: from mail.perches.com ([173.55.12.10]:1645 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab0AaUCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:23 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] fs/proc/array.c: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:10 -0800
Message-Id: <291731774b0e86b9de0b0e39cea5ee6960fe36cf.1264967500.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

The character at the end of the 3rd line is a tab not a space.
That was probably not intentional, but I'm not changing it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/proc/array.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 13b5d07..0b4c4ce 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -465,9 +465,10 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
-%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu "
+		   "%lu %lu %lu %lu %lu %ld %ld %ld %ld "
+		   "%d 0 %llu %lu %ld %lu %lu %lu %lu %lu	"
+		   "%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
-- 
1.6.6.rc0.57.gad7a


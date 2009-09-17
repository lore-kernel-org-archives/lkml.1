Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZIQWgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZIQWgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZIQWgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:36:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:46192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZIQWgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:36:05 -0400
Date: Thu, 17 Sep 2009 22:35:41 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AB1F4AB.7050205@cn.fujitsu.com>
References: <4AB1F4AB.7050205@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Increase MAX_EVENT_LENGTH
Message-ID: <tip-270bbbe80d82fad8b698d0b407eb3ad67cc3492b@git.kernel.org>
Git-Commit-ID: 270bbbe80d82fad8b698d0b407eb3ad67cc3492b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 22:35:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  270bbbe80d82fad8b698d0b407eb3ad67cc3492b
Gitweb:     http://git.kernel.org/tip/270bbbe80d82fad8b698d0b407eb3ad67cc3492b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 17 Sep 2009 16:34:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 00:30:25 +0200

perf tools: Increase MAX_EVENT_LENGTH

The name length of some trace events is longer than 30, like
sys_enter_sched_get_priority_max and
ext4_mb_discard_preallocations.

Passing those events to perf-record will fail, try:

  # ./perf record -f -e syscalls:sys_enter_sched_get_priority_max -F 1 -a

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4AB1F4AB.7050205@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 034245e..910283c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -145,7 +145,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 	   (strcmp(evt_dirent.d_name, "..")) &&				       \
 	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
 
-#define MAX_EVENT_LENGTH 30
+#define MAX_EVENT_LENGTH 512
 
 int valid_debugfs_mount(const char *debugfs)
 {

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZIQIgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZIQIgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZIQIgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:36:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZIQIgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:36:04 -0400
Message-ID: <4AB1F4AB.7050205@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 16:34:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf tools: Increase MAX_EVENT_LENGTH
References: <4AB1F48F.4070807@cn.fujitsu.com>
In-Reply-To: <4AB1F48F.4070807@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name length of some trace events is longer than 30, like
sys_enter_sched_get_priority_max and ext4_mb_discard_preallocations.

Passing those events to perf-record will fail, try:

  # ./perf record -f -e syscalls:sys_enter_sched_get_priority_max -F 1 -a

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 034245e..c9ef944 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -145,7 +145,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 	   (strcmp(evt_dirent.d_name, "..")) &&				       \
 	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
 
-#define MAX_EVENT_LENGTH 30
+#define MAX_EVENT_LENGTH 40
 
 int valid_debugfs_mount(const char *debugfs)
 {
-- 
1.6.3


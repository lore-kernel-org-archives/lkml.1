Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZIGIPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZIGIPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZIGIPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:15:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZIGIPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:15:09 -0400
Message-ID: <4AA4C0C4.9070907@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 16:13:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] perf trace: increase MAX_EVENT_LENGTH
References: <4AA4C04D.1050201@cn.fujitsu.com>
In-Reply-To: <4AA4C04D.1050201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name length of some trace events is longer than 30, like
sys_enter_sched_get_priority_max, ext4_mb_discard_preallocations.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a587d41..892d931 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -139,7 +139,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 	   (strcmp(evt_dirent.d_name, "..")) &&				       \
 	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
 
-#define MAX_EVENT_LENGTH 30
+#define MAX_EVENT_LENGTH 40
 
 int valid_debugfs_mount(const char *debugfs)
 {
-- 1.6.3 

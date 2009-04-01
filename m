Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbZDAISx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbZDAISx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZDAISg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:18:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54989 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbZDAISf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:18:35 -0400
Message-ID: <49D3236D.3090705@cn.fujitsu.com>
Date: Wed, 01 Apr 2009 16:18:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] blktrace: fix output of unknown events
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all events are pc (packet command) events. An event is a pc
event only if it has BLK_TC_PC bit set.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 947c5b3..464a6e5 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1181,7 +1181,7 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 	}
 
 	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
-		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
+		ret = trace_seq_printf(s, "Unknown action %x\n", what);
 	else {
 		ret = log_action(iter, what2act[what].act[long_act]);
 		if (ret)
-- 
1.5.4.rc3



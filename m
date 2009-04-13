Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZDMWY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZDMWY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZDMWX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:23:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZDMWXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:23:22 -0400
Date: Mon, 13 Apr 2009 22:22:22 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D3236D.3090705@cn.fujitsu.com>
References: <49D3236D.3090705@cn.fujitsu.com>
Subject: [tip:tracing/core] blktrace: fix output of unknown events
Message-ID: <tip-b78825d608f30a47e3154ab6872a03f0de0c9d45@git.kernel.org>
Git-Commit-ID: b78825d608f30a47e3154ab6872a03f0de0c9d45
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 22:22:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b78825d608f30a47e3154ab6872a03f0de0c9d45
Gitweb:     http://git.kernel.org/tip/b78825d608f30a47e3154ab6872a03f0de0c9d45
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 1 Apr 2009 16:18:53 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 15:32:45 +0200

blktrace: fix output of unknown events

Not all events are pc (packet command) events. An event is a pc
event only if it has BLK_TC_PC bit set.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49D3236D.3090705@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 921ef5d..e45e1af 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1182,7 +1182,7 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 	}
 
 	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
-		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
+		ret = trace_seq_printf(s, "Unknown action %x\n", what);
 	else {
 		ret = log_action(iter, what2act[what].act[long_act]);
 		if (ret)

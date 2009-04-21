Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZDUJLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZDUJLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZDUJKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:10:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZDUJKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:10:52 -0400
Message-ID: <49ED8DD2.2070700@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 17:11:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/filters: don't remove old filters when failed
 to write subsys->filter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If writing subsys->filter returns EINVAL or ENOSPC, the original
filters in subsys/ and subsys/events/ will be removed. This is
definitely wrong.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index aabf6ea..38cb568 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -600,7 +600,6 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	err = filter_add_subsystem_pred(system, pred);
 	if (err < 0) {
-		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
 		return err;
 	}
-- 
1.5.4.rc3

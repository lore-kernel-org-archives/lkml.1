Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbYDAEbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbYDAEbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 00:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYDAEbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 00:31:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55261 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYDAEbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 00:31:32 -0400
Message-ID: <47F1BA2E.9040706@cn.fujitsu.com>
Date: Tue, 01 Apr 2008 12:29:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tony.luck@intel.com
CC: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] IA64: use goto to jump out do/while_each_thread
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_each_thread/while_each_thread is a double loop, so
should use 'goto' rather than 'break' to break out
the loop.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 arch/ia64/kernel/perfmon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index a2aabfd..d1d24f4 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -4204,10 +4204,10 @@ pfm_check_task_exist(pfm_context_t *ctx)
 	do_each_thread (g, t) {
 		if (t->thread.pfm_context == ctx) {
 			ret = 0;
-			break;
+			goto out;
 		}
 	} while_each_thread (g, t);
-
+out:
 	read_unlock(&tasklist_lock);
 
 	DPRINT(("pfm_check_task_exist: ret=%d ctx=%p\n", ret, ctx));
-- 
1.5.4.rc3

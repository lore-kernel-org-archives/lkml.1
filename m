Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYJaIxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYJaIxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYJaIxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:53:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbYJaIxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:53:05 -0400
Message-ID: <490AC707.1060808@cn.fujitsu.com>
Date: Fri, 31 Oct 2008 16:51:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org
Subject: [PATCH] fork.c: cleanup for copy_sighand()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check CLONE_SIGHAND only is enough, because combination of CLONE_THREAD and
CLONE_SIGHAND is already done in copy_process().

Impact: cleanup, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f608356..36a0dac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -741,7 +741,7 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 
-	if (clone_flags & (CLONE_SIGHAND | CLONE_THREAD)) {
+	if (clone_flags & CLONE_SIGHAND) {
 		atomic_inc(&current->sighand->count);
 		return 0;
 	}
-- 
1.5.5.3



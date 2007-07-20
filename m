Return-Path: <linux-kernel-owner+w=401wt.eu-S1765979AbXGTSmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765979AbXGTSmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbXGTSl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:41:58 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52267 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625AbXGTSl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:41:57 -0400
Subject: [PATCH] Mark sysrq_sched_debug_show static.
From: Josh Triplett <josh@kernel.org>
Reply-To: josh@kernel.org, josht@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:42:16 -0700
Message-Id: <1184956936.2630.12.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Only sched.c uses sysrq_sched_debug_show, and sched.c includes sched_debug.c,
so all uses of sysrq_sched_debug_show occur in the same source file.

Eliminates a sparse warning:
warning: symbol 'sysrq_sched_debug_show' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 kernel/sched_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 29f2c21..42970f7 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -186,7 +186,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-void sysrq_sched_debug_show(void)
+static void sysrq_sched_debug_show(void)
 {
 	sched_debug_show(NULL, NULL);
 }
-- 
1.5.2.1




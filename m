Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZCWUQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZCWUQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZCWUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:16:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZCWUQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:16:30 -0400
Date: Mon, 23 Mar 2009 16:16:28 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] degrade severity of lockdep printk
Message-ID: <20090323201628.GB19208@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

While it means something is awry, the BUG prefix confuses users and
possibly the kerneloops tool. It's also being trivially exhausted in
normal use on my laptop and several other folks machines, but that will
need another look.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06b0c35..139a81a 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -368,7 +368,7 @@ static int save_trace(struct stack_trace *trace)
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
+		printk("warning: MAX_STACK_TRACE_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
 		dump_stack();
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXFTR7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXFTR7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXFTR7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:59:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:31675 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXFTR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pr2bKECTd02j/Fsa0Vlrj4PWH6Nm5Uk5PVL/igxVyz0LlsIup2jUmTEO/cHFDgw3o+hPBkgHIiBI8RDBnmURYDADuV1T4C5hTB9K2/hJzPefGYQ/1yyofAe7QSeJm7JDGenkmNR9+9BOpSFGvra5j0RDxDrnz3jA71EP0qj0eBA=
Date: Wed, 20 Jun 2007 21:57:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bracing the loop in kernel/softirq.c
Message-ID: <20070620175737.GA6523@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch adds braces over a one-line
loop. That makes code...well... little bit
convenient for (possible) further modifications.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 kernel/softirq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0b9886a..d1a7e89 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -470,9 +470,9 @@ void tasklet_kill(struct tasklet_struct *t)
 		printk("Attempt to kill tasklet from interrupt\n");
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
-		do
+		do {
 			yield();
-		while (test_bit(TASKLET_STATE_SCHED, &t->state));
+		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbXFJS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbXFJS6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXFJS6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:58:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:33203 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXFJS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JHgz4EbqbtgvS5twcIxK3JMiRYfupopw6QzXF2KxHRuNTZtfWNn/XcMnxKooOXhD1SCMRF/siqbC2agN+lczLkePM/As74j8aqeC+iW7dgGVyYxEh3iRZAdA4qSTqLlmS6oJE9vORSaJ3+bKXB+KEUmbuB/hv2SzAo+3+wbbBvA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove unneeded test of 'task' in dump_trace()
Date: Sun, 10 Jun 2007 20:58:42 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706102058.42727.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded test of task != NULL from 
arch/i386/kernel/traps.c::dump_trace()

At the start of the function we have this test:
        if (!task)
                task = current;
so further down there's no need to test 'task'.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 arch/i386/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 90da057..f29a61d 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -148,7 +148,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!stack) {
 		unsigned long dummy;
 		stack = &dummy;
-		if (task && task != current)
+		if (task != current)
 			stack = (unsigned long *)task->thread.esp;
 	}
 

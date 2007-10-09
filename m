Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbXJIXt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbXJIXt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXJIXtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:49:18 -0400
Received: from balanced.mail.policyd.dreamhost.com ([208.97.132.119]:53203
	"EHLO jankymail-a5.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300AbXJIXtS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:49:18 -0400
X-Greylist: delayed 34144 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 19:49:17 EDT
Date: Tue, 9 Oct 2007 19:48:20 -0400
From: Gustavo Chain <g@0xff.cl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Reserve N process to root
Message-ID: <20071009194820.6c8d6e8d@0xff.cl>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think it's necessary to reserve some pids to the super user.
5 must be sufficient.

Signed-off-by: Gustavo Chain <g@0xff.cl>
---
 kernel/fork.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 33f12f4..db23cb3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1367,11 +1367,17 @@ long do_fork(unsigned long clone_flags,
              int __user *parent_tidptr,
              int __user *child_tidptr)
 {
+#define RESERVED_PIDS   5
+
        struct task_struct *p;
        int trace = 0;
        struct pid *pid = alloc_pid();
        long nr;
 
+       if (!capable(CAP_SYS_ADMIN) && nr_threads >= max_threads
- RESERVED_PIDS) {
+               return -EAGAIN;
+       }
+
        if (!pid)
                return -EAGAIN;
        nr = pid->nr;

-- 
Gustavo Chaín Dumit

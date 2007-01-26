Return-Path: <linux-kernel-owner+w=401wt.eu-S1030817AbXAZQra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030817AbXAZQra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030834AbXAZQra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:47:30 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:19046 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030817AbXAZQr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:47:29 -0500
Date: Fri, 26 Jan 2007 17:47:21 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akinobu.mita@gmail.com
Subject: [S390] Check the return value of kthread_run().
Message-ID: <20070126164721.GC11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[S390] Check the return value of kthread_run().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

---

 drivers/s390/s390mach.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/s390mach.c linux-2.6-patched/drivers/s390/s390mach.c
--- linux-2.6/drivers/s390/s390mach.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/drivers/s390/s390mach.c	2007-01-26 17:27:47.000000000 +0100
@@ -525,7 +525,11 @@ arch_initcall(machine_check_init);
 static int __init
 machine_check_crw_init (void)
 {
-	kthread_run(s390_collect_crw_info, &m_sem, "kmcheck");
+	struct task_struct *task;
+
+	task = kthread_run(s390_collect_crw_info, &m_sem, "kmcheck");
+	if (IS_ERR(task))
+		return PTR_ERR(task);
 	ctl_set_bit(14, 28);	/* enable channel report MCH */
 	return 0;
 }

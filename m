Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZDPXbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZDPXbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZDPXaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:30:52 -0400
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:48598 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755718AbZDPXav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:30:51 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] kernel/softirq.c: fix sparse warning
Date: Thu, 16 Apr 2009 19:30:18 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9033@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] kernel/softirq.c: fix sparse warning
Thread-Index: Acm+603XlYHhWhTzQcCfj6thX9S2aw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 23:30:49.0860 (UTC) FILETIME=[60469440:01C9BEEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning in kernel/softirq.c.

  warning: do-while statement is not a compound statement

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2fecefa..b525dd3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -472,9 +472,9 @@ void tasklet_kill(struct tasklet_struct *t)
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

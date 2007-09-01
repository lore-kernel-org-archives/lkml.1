Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXIAW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXIAW7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXIAW7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:59:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56923 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXIAW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:59:16 -0400
Date: Sun, 2 Sep 2007 04:42:23 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -mm] softlockup-improve-debug-output.patch fix
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709020439290.20781@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


kernel/softlockup.c: In function 'softlockup_tick':
kernel/softlockup.c:125: warning: 'regs' is used uninitialized in this function

So let's fix softlockup-improve-debug-output.patch to actually work,
and do what it claimed in the changelog :-)

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 softlockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- kernel/softlockup.c~fix	2007-09-02 04:23:49.000000000 +0530
+++ kernel/softlockup.c	2007-09-02 04:34:45.000000000 +0530
@@ -80,7 +80,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
-	struct pt_regs *regs;
+	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	if (touch_timestamp == 0) {

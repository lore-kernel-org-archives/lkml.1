Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbXLISgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbXLISgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXLISga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:36:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:39469 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbXLISg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lZHCwkdVm+eC1Lujc8j1zF7o6lSIRz2XCHZM8hgoXwKDpiUcOKuUv4Eh2OMSsxcc0fBPkMT3hf3ikNPAPW51vTILnWbRMz+hcn46W2roqm5xcf4OQB4vSh9M9jFuoIRCakgcux2tzwXjU8Z7EFur3V+PmoxMg4rn/D2TlqNtKTk=
Subject: [PATCH git-sched 1/3] no need for 'affine wakeup' balancing in
	select_task_rq_fair() when task_cpu(p) == this_cpu
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 19:36:22 +0100
Message-Id: <1197225382.6991.23.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

No need to do a check for 'affine wakeup and passive balancing possibilities' in
select_task_rq_fair() when task_cpu(p) == this_cpu.

I guess, this part got missed upon introduction of per-sched_class select_task_rq()
in try_to_wake_up().

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f881fc5..2208692 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -925,6 +925,9 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	this_cpu = smp_processor_id();
 	new_cpu  = cpu;
 
+	if (cpu == this_cpu)
+		goto out_set_cpu;
+
 	for_each_domain(this_cpu, sd) {
 		if (cpu_isset(cpu, sd->span)) {
 			this_sd = sd;



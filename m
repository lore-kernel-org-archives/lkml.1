Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbYCJMOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbYCJMOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYCJMOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:14:07 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55347 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYCJMOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:14:06 -0400
Date: Mon, 10 Mar 2008 17:44:03 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: [PATCH] x86: Don't send RESCHEDULE_VECTOR to offlined cpus
Message-ID: <20080310121403.GD17646@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Don't send RESCHEDULE_VECTOR to offlined cpus.
From: Gautham R Shenoy <ego@in.ibm.com>

In the x86 native_smp_send_reschedule_function(), don't send the IPI if the
cpu has gone offline already. Warn nevertheless!!

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 arch/x86/kernel/smp_32.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index dc0cde9..4df9042 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -472,7 +472,10 @@ void flush_tlb_all(void)
  */
 static void native_smp_send_reschedule(int cpu)
 {
-	WARN_ON(cpu_is_offline(cpu));
+	if (unlikely(cpu_is_offline(cpu))) {
+		WARN_ON(1);
+		return;
+	}
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
-- 
Thanks and Regards
gautham

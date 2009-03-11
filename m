Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZCKBOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZCKBOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZCKBOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:14:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53948 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZCKBOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:14:31 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for -tip] x86, mce: use round_jiffies() instead round_jiffies_relative()
Cc: kosaki.motohiro@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Message-Id: <20090311100925.A7FA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 11 Mar 2009 10:14:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: saving power _very_ little

round_jiffies() round up absolute jiffies to full second.
round_jiffies_relative() round up relative jiffies to full second.

The "t->expires" is absolute jiffies. Then, round_jiffies() should be
used instead round_jiffies_relative().


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index bfbd532..ca14604 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -639,7 +639,7 @@ static void mce_init_timer(void)
 	if (!next_interval)
 		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
-	t->expires = round_jiffies_relative(jiffies + next_interval);
+	t->expires = round_jiffies(jiffies + next_interval);
 	add_timer(t);
 }
 
@@ -1110,7 +1110,7 @@ static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		t->expires = round_jiffies_relative(jiffies + next_interval);
+		t->expires = round_jiffies(jiffies + next_interval);
 		add_timer_on(t, cpu);
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		break;
-- 
1.6.1.2




Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZLCVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZLCVco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZLCVco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:32:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbZLCVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:32:43 -0500
Date: Thu, 3 Dec 2009 22:32:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/xen for v2.6.33
Message-ID: <20091203213234.GA5936@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-xen-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-xen-for-linus

 Thanks,

	Ingo

------------------>
Rusty Russell (1):
      cpumask: Use modern cpumask style in Xen


 arch/x86/xen/smp.c        |    2 +-
 drivers/xen/cpu_hotplug.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index fe03eee..738da0c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -73,7 +73,7 @@ static __cpuinit void cpu_bringup(void)
 
 	xen_setup_cpu_clockevents();
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	percpu_write(cpu_state, CPU_ONLINE);
 	wmb();
 
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index bdfd584..0f765a9 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -86,7 +86,7 @@ static int setup_cpu_watcher(struct notifier_block *notifier,
 	for_each_possible_cpu(cpu) {
 		if (vcpu_online(cpu) == 0) {
 			(void)cpu_down(cpu);
-			cpu_clear(cpu, cpu_present_map);
+			set_cpu_present(cpu, false);
 		}
 	}
 

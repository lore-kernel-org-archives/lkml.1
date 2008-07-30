Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbYG3Xe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbYG3Xe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760348AbYG3Xea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:34:30 -0400
Received: from mail.suse.de ([195.135.220.2]:35568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760330AbYG3Xe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:34:28 -0400
Date: Wed, 30 Jul 2008 16:26:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/29] sparc64: Fix cpufreq notifier registry.
Message-ID: <20080730232657.GH30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-cpufreq-notifier-registry.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 7ae93f51d7fa8b9130d47e0b7d17979a165c5bc3 ]

Based upon a report by Daniel Smolik.

We do it too early, which triggers a BUG in
cpufreq_register_notifier().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/time.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -883,6 +883,16 @@ static struct notifier_block sparc64_cpu
 	.notifier_call	= sparc64_cpufreq_notifier
 };
 
+static int __init register_sparc64_cpufreq_notifier(void)
+{
+
+	cpufreq_register_notifier(&sparc64_cpufreq_notifier_block,
+				  CPUFREQ_TRANSITION_NOTIFIER);
+	return 0;
+}
+
+core_initcall(register_sparc64_cpufreq_notifier);
+
 #endif /* CONFIG_CPU_FREQ */
 
 static int sparc64_next_event(unsigned long delta,
@@ -1049,11 +1059,6 @@ void __init time_init(void)
 	       sparc64_clockevent.mult, sparc64_clockevent.shift);
 
 	setup_sparc64_timer();
-
-#ifdef CONFIG_CPU_FREQ
-	cpufreq_register_notifier(&sparc64_cpufreq_notifier_block,
-				  CPUFREQ_TRANSITION_NOTIFIER);
-#endif
 }
 
 unsigned long long sched_clock(void)

-- 

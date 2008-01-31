Return-Path: <linux-kernel-owner+w=401wt.eu-S934915AbYAaWM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915AbYAaWM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764922AbYAaWKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:42 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40283 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934228AbYAaWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:37 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] cpu: do not annotate exported register_cpu_notifier()
Date: Thu, 31 Jan 2008 23:10:34 +0100
Message-Id: <1201817440-5081-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: o-x86_64/kernel/built-in.o(__ksymtab+0xfb0): Section mismatch in reference from the variable __ksymtab_register_cpu_notifier to the function .cpuinit.text:register_cpu_notifier()

register_cpu_notifier() are used from modules that may be
loaded long after init has completed.
Drop the annotation so the function is kept after init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index df9430f..6fc9864 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -136,7 +136,7 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
-int __cpuinit register_cpu_notifier(struct notifier_block *nb)
+int register_cpu_notifier(struct notifier_block *nb)
 {
 	int ret;
 	cpu_maps_update_begin();
-- 
1.5.4.rc3.14.g44397


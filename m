Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXHWCu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXHWCu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXHWCut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:50:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59599 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXHWCus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:50:48 -0400
Date: Thu, 23 Aug 2007 08:33:41 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Dave Jones <davej@codemonkey.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: Implement !CONFIG_CPU_FREQ stub for
 cpufreq_unregister_notifier()
Message-ID: <alpine.LFD.0.999.0708230832290.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Callsites such as arch/powerpc/oprofile/op_model_cell.c are having to
open-code #ifdef CONFIG_CPU_FREQ only to be able to get at the full
definition of cpufreq_unregister_notifier(), because no empty stub is
available for the !CONFIG_CPU_FREQ case. Let's provide one, to be able
to remove such #ifdef's from the rest of the kernel tree -- those will
come in a subsequent patch.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 include/linux/cpufreq.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 963051a..6e2ebd8 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -34,14 +34,19 @@
 
 #ifdef CONFIG_CPU_FREQ
 int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
+int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 #else
 static inline int cpufreq_register_notifier(struct notifier_block *nb,
 						unsigned int list)
 {
 	return 0;
 }
+static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
+						unsigned int list)
+{
+	return 0;
+}
 #endif
-int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 
 #define CPUFREQ_TRANSITION_NOTIFIER	(0)
 #define CPUFREQ_POLICY_NOTIFIER		(1)

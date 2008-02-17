Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYBQMYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYBQMYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYBQMXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:03 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38331 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 06/27] cpu: fix section mismatch warning in unregister_cpu_notifier
Date: Sun, 17 Feb 2008 13:22:43 +0100
Message-Id: <1203250984-11285-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x75f4e): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain

We know that unregister_cpu_notifier is using HOTPLUG_CPU
stuff - so ignore these references.
Annotating unregister_cpu_notifier had been another option
but this caused far more warnings since not all callers were
annotated __cpuinit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2eff3f6..cdebf33 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -149,7 +149,7 @@ int __cpuinit register_cpu_notifier(struct notifier_block *nb)
 
 EXPORT_SYMBOL(register_cpu_notifier);
 
-void unregister_cpu_notifier(struct notifier_block *nb)
+void __ref unregister_cpu_notifier(struct notifier_block *nb)
 {
 	cpu_maps_update_begin();
 	raw_notifier_chain_unregister(&cpu_chain, nb);
-- 
1.5.4.rc3.14.g44397


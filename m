Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbYAaWMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbYAaWMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934447AbYAaWKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40286 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934322AbYAaWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:37 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] cpu: fix section mismatch warnings for enable_nonboot_cpus
Date: Thu, 31 Jan 2008 23:10:32 +0100
Message-Id: <1201817440-5081-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: o-x86_64/kernel/built-in.o(.text+0x36d8b): Section mismatch in reference from the function enable_nonboot_cpus() to the function .cpuinit.text:_cpu_up()

enable_nonboot_cpus() are used solely from CONFIG_CONFIG_PM_SLEEP_SMP=y
and PM_SLEEP_SMP imply HOTPLUG_CPU therefore the reference
to _cpu_up() is valid.
Annotate enable_nonboot_cpus() with __ref to silence modpost.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index e0d3a4f..2eff3f6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -389,7 +389,7 @@ int disable_nonboot_cpus(void)
 	return error;
 }
 
-void enable_nonboot_cpus(void)
+void __ref enable_nonboot_cpus(void)
 {
 	int cpu, error;
 
-- 
1.5.4.rc3.14.g44397


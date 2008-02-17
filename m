Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYBQMXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYBQMXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbYBQMW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:22:58 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55045 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 08/27] cpu: fix section mismatch warning in reference to register_cpu_notifier
Date: Sun, 17 Feb 2008 13:22:45 +0100
Message-Id: <1203250984-11285-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0xc60): Section mismatch in reference from the function kvm_init() to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(.text+0x33869a): Section mismatch in reference from the function xfs_icsb_init_counters() to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(.text+0x5556a1): Section mismatch in reference from the function acpi_processor_install_hotplug_notify() to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(.text+0xfe6b28): Section mismatch in reference from the function cpufreq_register_driver() to the function .cpuinit.text:register_cpu_notifier()

register_cpu_notifier() are only really defined when HOTPLUG_CPU
is enabled. So references to the function are OK.
Annotate it with __ref so we do not get warnings from
callers and do not get warnings for the functions/data
used by register_cpu_notifier().

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 74827bf..329fdcb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -136,7 +136,7 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
-int __cpuinit register_cpu_notifier(struct notifier_block *nb)
+int __ref register_cpu_notifier(struct notifier_block *nb)
 {
 	int ret;
 	cpu_maps_update_begin();
-- 
1.5.4.rc3.14.g44397


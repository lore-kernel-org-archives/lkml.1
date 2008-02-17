Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYBQM0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYBQM0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbYBQMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55059 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/27] x86: fix section mismatch warning in topology.c:arch_register_cpu
Date: Sun, 17 Feb 2008 13:22:49 +0100
Message-Id: <1203250984-11285-12-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x1dfc3): Section mismatch in reference from the function arch_register_cpu() to the function .cpuinit.text:register_cpu()

arch_register_cpu() is only defined for HOTPLUG_CPU code
so simple fix is to ignore references by annotating the
function __ref.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/topology.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index a40051b..0fcc95a 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -34,7 +34,7 @@
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
-int arch_register_cpu(int num)
+int __ref arch_register_cpu(int num)
 {
 	/*
 	 * CPU0 cannot be offlined due to several
-- 
1.5.4.rc3.14.g44397


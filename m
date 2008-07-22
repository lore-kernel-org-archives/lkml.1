Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYGVFbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYGVFbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYGVFXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbYGVFXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 28/79] device create: x86: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:52 -0700
Message-Id: <1216703983-21448-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpuid.c |    4 ++--
 arch/x86/kernel/msr.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 2de5fa2..14b11b3 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -141,8 +141,8 @@ static __cpuinit int cpuid_device_create(int cpu)
 {
 	struct device *dev;
 
-	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu),
-			    "cpu%d", cpu);
+	dev = device_create_drvdata(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu),
+				    NULL, "cpu%d", cpu);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index a153b39..9fd8095 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -149,8 +149,8 @@ static int __cpuinit msr_device_create(int cpu)
 {
 	struct device *dev;
 
-	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu),
-			    "msr%d", cpu);
+	dev = device_create_drvdata(msr_class, NULL, MKDEV(MSR_MAJOR, cpu),
+				    NULL, "msr%d", cpu);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 
-- 
1.5.6.3


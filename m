Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbXKZIfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbXKZIfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXKZIfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:35:41 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43338 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXKZIfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:35:41 -0500
Date: Mon, 26 Nov 2007 00:38:41 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: not set boot cpu in cpu_online_map at
 smp_prepare_boot_cpu
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200711260038.41710.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: not set boot cpu in cpu_online_map at smp_prepare_boot_cpu

in init/main.c boot_cpu_init() does that before

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 500670c..966d124 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -912,7 +912,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 void __init smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
-	cpu_set(me, cpu_online_map);
+	/* already set me in cpu_online_map in boot_cpu_init() */
 	cpu_set(me, cpu_callout_map);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }

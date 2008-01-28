Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbYA1CVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbYA1CVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 21:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYA1CV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 21:21:26 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55091 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYA1CVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:21:24 -0500
Date: Sun, 27 Jan 2008 18:28:05 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: not set boot cpu in cpu_online_map at
 smp_prepare_boot_cpu
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801271828.05543.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: not set boot cpu in cpu_online_map at smp_prepare_boot_cpu

in init/main.c boot_cpu_init() does that before

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6/arch/x86/kernel/smpboot_64.c
@@ -921,7 +921,7 @@ void __init smp_prepare_cpus(unsigned in
 void __init smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
-	cpu_set(me, cpu_online_map);
+	/* already set me in cpu_online_map in boot_cpu_init() */
 	cpu_set(me, cpu_callout_map);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }

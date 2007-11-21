Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXKUDf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXKUDf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 22:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXKUDfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 22:35:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64106 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbXKUDfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 22:35:50 -0500
Date: Tue, 20 Nov 2007 19:38:27 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] CPUFREQ: powernow-k8 print pstate instead of fid/did for
 family 10h
To: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200711201938.28110.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] CPUFREQ: powernow-k8 print pstate instead of fid/did for family 10h

powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 8354 processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x0 did 0x0 (2200 MHz)
powernow-k8:    1 : fid 0x0 did 0x0 (2000 MHz)
powernow-k8:    2 : fid 0x0 did 0x0 (1700 MHz)
powernow-k8:    3 : fid 0x0 did 0x0 (1400 MHz)
powernow-k8:    4 : fid 0x0 did 0x0 (1100 MHz)

actually index for CPU_HW_PSTATE is pstate instead of fid/vid
So print it out as pstate.

powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 8354 processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (2200 MHz)
powernow-k8:    1 : pstate 1 (2000 MHz)
powernow-k8:    2 : pstate 2 (1700 MHz)
powernow-k8:    3 : pstate 3 (1400 MHz)
powernow-k8:    4 : pstate 4 (1100 MHz)

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -578,10 +578,9 @@ static void print_basics(struct powernow
 	for (j = 0; j < data->numps; j++) {
 		if (data->powernow_table[j].frequency != CPUFREQ_ENTRY_INVALID) {
 			if (cpu_family == CPU_HW_PSTATE) {
-				printk(KERN_INFO PFX "   %d : fid 0x%x did 0x%x (%d MHz)\n",
+				printk(KERN_INFO PFX "   %d : pstate %d (%d MHz)\n",
 					j,
-					(data->powernow_table[j].index & 0xff00) >> 8,
-					(data->powernow_table[j].index & 0xff0000) >> 16,
+					data->powernow_table[j].index,
 					data->powernow_table[j].frequency/1000);
 			} else {
 				printk(KERN_INFO PFX "   %d : fid 0x%x (%d MHz), vid 0x%x\n",

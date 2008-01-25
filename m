Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYAYMcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYAYMcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYAYMc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:32:26 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:13622 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397AbYAYMcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:32:25 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JV79C8-01-9YO-01
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Fri, 25 Jan 2008 13:28:34 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix cpu MHz reporting for AMD family 0x11
Message-ID: <20080125122834.GA6978@alberich.amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Jan 2008 12:28:34.0595 (UTC)
 FILETIME=[CD900F30:01C85F4D]
X-WSS-ID: 6B87098F24S9035826-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cpu MHz reporting for AMD family 0x11 when powernow-k8 is
disabled.

Just adhere to the CONSTANT_TSC feature bit for AMD CPUs when deciding
whether cpu_khz needs calibration. The additional check for CPU family
is not needed and prevents calibration for future CPUs.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

---
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 61b17f5..0380795 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -120,8 +120,7 @@ void __init time_init(void)
 
 	cpu_khz = tsc_khz;
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-		boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		boot_cpu_data.x86 == 16)
+		(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
 		cpu_khz = calculate_cpu_khz();
 
 	if (unsynchronized_tsc())




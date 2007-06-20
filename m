Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbXFTSs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbXFTSs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762616AbXFTSmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:42:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20750 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762737AbXFTSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:42:07 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:41:02 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 1/8] 2.6.22-rc3 perfmon2 : Barcelona CPU detection
Message-ID: <20070620184102.GB5874@erda.amd.com>
References: <20070620182126.248753000@amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:41:03.0018 (UTC)
 FILETIME=[8DCB88A0:01C7B36A]
X-WSS-ID: 6A67AB651S4957742-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=perfmon2-fam10h-001.diff
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements Barcelona CPU detection.

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
+++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
@@ -1059,6 +1059,7 @@ char *pfm_arch_get_pmu_module_name(void)
 			goto try_arch;
 		}
 	case 15:
+	case 16:
 		/* All Opteron processors */
 		if (cpu_data->x86_vendor == X86_VENDOR_AMD)
 			return "perfmon_k8";
Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
+++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
@@ -307,7 +307,12 @@ static int pfm_k8_probe_pmu(void)
 		return -1;
 	}
 
-	if (current_cpu_data.x86 != 15) {
+	switch (current_cpu_data.x86) {
+	case 15:
+	case 16:
+		PFM_INFO("found family=%d", current_cpu_data.x86);
+		break;
+	default:
 		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
 		return -1;
 	}

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com




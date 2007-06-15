Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXFOQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXFOQ5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXFOQ5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:57:06 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64657 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085AbXFOQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:57:04 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 15 Jun 2007 18:57:30 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [patch 1/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070615093330.845322000@localhost>
References: <20070614215818.509851000@localhost>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Jun 2007 16:56:44.0269 (UTC)
 FILETIME=[273979D0:01C7AF6E]
X-WSS-ID: 6A6C1B4523K500763-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
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





Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbXFDSJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbXFDSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXFDSJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:09:52 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:32807 "EHLO
	mail187-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752817AbXFDSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:09:51 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 14:09:51 EDT
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Mon, 4 Jun 2007 19:49:26 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org, "Joachim Deguara" <joachim.deguara@amd.com>,
       "Nagendra, Bhavana" <bhavana.nagendra@amd.com>
Subject: [PATCH] x86_64: remove check for CONSTANT_TSC from time.c
Message-ID: <20070604174926.GA22013@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Jun 2007 17:49:26.0967 (UTC)
 FILETIME=[B1CBA470:01C7A6D0]
X-WSS-ID: 6A7A8F2320G4009542-01-01
Content-Type: multipart/mixed;
 boundary=x+6KMIRAuhnl3hBn
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch removes the check for the CONSTANT_TSC cpu flag from time.c
on the x86_64 architecture. At the time this flag is checked at boot the
cpu init code was yet not executed and thus the check fails. At this
point the check for VENDOR_AMD and cpu family 0x10 is sufficient.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

--x+6KMIRAuhnl3hBn
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=gh-tsc-fix-fix.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 4a0895b..8b29928 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -394,9 +394,9 @@ void __init time_init(void)
 	}
 
 	cpu_khz = tsc_khz;
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-		boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 		boot_cpu_data.x86 == 16)
+		/* AMD Family 0x10 processors have a constant tsc */
 		cpu_khz = tsc_calibrate_cpu_khz();
 
 	if (unsynchronized_tsc())

--x+6KMIRAuhnl3hBn--



Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXCANAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXCANAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXCANAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:00:20 -0500
Received: from mail-cpk.bigfish.com ([207.46.163.10]:42071 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933264AbXCANAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:00:18 -0500
X-Greylist: delayed 5292 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 08:00:18 EST
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Thu, 1 Mar 2007 12:31:21 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] remove constant_tsc reporting from /proc/cpuinfo' power
 flags
Message-ID: <20070301113121.GB26809@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Mar 2007 11:31:48.0726 (UTC)
 FILETIME=[33303160:01C75BF5]
X-WSS-ID: 69F8662D2MC9409152-01-01
Content-Type: multipart/mixed;
 boundary=HlL+5n6rz5pIUxbD
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch removes the reporting of the constant_tsc flag from the
"power management" field in /proc/cpuinfo. The NULL value there was
replaced by "" because the former would result in a printout of [8] if
the flag is set.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--HlL+5n6rz5pIUxbD
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=cleanup-tsc_invariant-reporting.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/i386/kernel/cpu/proc.c b/arch/i386/kernel/cpu/proc.c
index 47e3ebb..89d91e6 100644
--- a/arch/i386/kernel/cpu/proc.c
+++ b/arch/i386/kernel/cpu/proc.c
@@ -72,8 +72,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		"stc",
 		"100mhzsteps",
 		"hwpstate",
-		NULL,
-		NULL,	/* constant_tsc - moved to flags */
+		"",	/* constant_tsc - moved to flags */
 		/* nothing */
 	};
 	struct cpuinfo_x86 *c = v;
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index 3d98b69..4aad515 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -987,9 +987,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		"stc",
 		"100mhzsteps",
 		"hwpstate",
-		NULL,	/* tsc invariant mapped to constant_tsc */
-		NULL,
-		/* nothing */	/* constant_tsc - moved to flags */
+		"",	/* tsc invariant mapped to constant_tsc */
+		/* nothing */
 	};
 
 

--HlL+5n6rz5pIUxbD--



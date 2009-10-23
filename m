Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZJWXif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZJWXif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZJWXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:38:33 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49155 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752863AbZJWXhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:37:55 -0400
Message-Id: <20091023233756.941535000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:49 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andreas Mohr <andi@lisas.de>, Hugh Dickins <hugh@veritas.com>,
       Hannes Eder <hannes@hanneseder.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
Content-Disposition: inline; filename=limit_microcode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit number of microcode messages of the form:

[   50.887135] microcode: CPU0 sig=0x206e5, pf=0x4, revision=0xffff001

Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Hannes Eder <hannes@hanneseder.net>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/microcode_intel.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/microcode_intel.c
+++ linux/arch/x86/kernel/microcode_intel.c
@@ -165,7 +165,9 @@
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
 
-	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
+	if (cpu_num < 4 || !limit_console_output(false))
+		printk(KERN_INFO
+			"microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
 			cpu_num, csig->sig, csig->pf, csig->rev);
 
 	return 0;

-- 

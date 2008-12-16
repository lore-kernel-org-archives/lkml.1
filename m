Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYLPCY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYLPCY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYLPCYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:14 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40527 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802AbYLPCYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:13 -0500
Message-Id: <20081216022411.201080000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:19 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] x86: Set CONFIG_NR_CPUS even on UP
Content-Disposition: inline; filename=0014-x86-Set-CONFIG_NR_CPUS-even-on-UP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 09638b1..309f8bb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -589,12 +589,12 @@ config MAXSMP
 	  If unsure, say N.
 
 config NR_CPUS
-	depends on SMP
 	int "Maximum number of CPUs" if SMP && !MAXSMP
 	range 2 512 if SMP && !MAXSMP
+	default "1" if !SMP
 	default "4096" if MAXSMP
-	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
-	default "8"
+	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
+	default "8" if SMP
 	help
 	  This allows you to specify the maximum number of CPUs which this
 	  kernel will support.  The maximum supported value is 512 and the
-- 
1.6.0

-- 

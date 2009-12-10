Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbZLJNch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbZLJNch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759499AbZLJNcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:32:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40134 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898AbZLJNcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NL178NxsmHCuFLg2El2Ov7OUuG5VtAwP+OKUVw84HLE9b+klzzMYn76lzcbKvI6D60
         Gb8+x2tTqtJhV7ZPxc3v22Aa4kCNo679tDsDen4XNuogsgPG8nIXhKqzd0J61fasIrgY
         N91fj9wjBdsCbbKap7Y11QvsGx7drMqn0rTcE=
Date: Thu, 10 Dec 2009 14:32:33 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] x86, amd: Make check_c1e_idle explicit
Message-ID: <20091210133232.GA5471@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CC: stable@kernel.org
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/process.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ea54ce8..1bf98b1 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -494,21 +494,19 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 }
 
 /*
- * Check for AMD CPUs, which have potentially C1E support
+ * Check for AMD CPUs, which potentially use SMI or hardware initiated C1E
  */
 static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	if (c->x86 < 0x0F)
-		return 0;
-
-	/* Family 0x0f models < rev F do not have C1E */
-	if (c->x86 == 0x0f && c->x86_model < 0x40)
-		return 0;
+	if ((c->x86 == 0x0F && c->x86_model >= 0x40) ||
+	    (c->x86 == 0x10) ||
+	    (c->x86 == 0x11))
+		return 1;
 
-	return 1;
+	return 0;
 }
 
 static cpumask_var_t c1e_mask;
-- 
1.6.4.2


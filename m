Return-Path: <linux-kernel-owner+w=401wt.eu-S964779AbXBLHrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779AbXBLHrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933077AbXBLHq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:58 -0500
Received: from mail.suse.de ([195.135.220.2]:38367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbXBLHhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:53 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Rene Herman <rene.herman@gmail.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [6/39] i386: romsignature/checksum cleanup
Message-Id: <20070212073752.5B5AA13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rene Herman <rene.herman@gmail.com>

Use adding __init to romsignature() (it's only called from probe_roms()
which is itself __init) as an excuse to submit a pedantic cleanup.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/e820.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/e820.c
===================================================================
--- linux.orig/arch/i386/kernel/e820.c
+++ linux/arch/i386/kernel/e820.c
@@ -157,21 +157,22 @@ static struct resource standard_io_resou
 	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
 } };
 
-static int romsignature(const unsigned char *x)
+#define ROMSIGNATURE 0xaa55
+
+static int __init romsignature(const unsigned char *rom)
 {
 	unsigned short sig;
-	int ret = 0;
-	if (probe_kernel_address((const unsigned short *)x, sig) == 0)
-		ret = (sig == 0xaa55);
-	return ret;
+
+	return probe_kernel_address((const unsigned short *)rom, sig) == 0 &&
+	       sig == ROMSIGNATURE;
 }
 
 static int __init romchecksum(unsigned char *rom, unsigned long length)
 {
-	unsigned char *p, sum = 0;
+	unsigned char sum;
 
-	for (p = rom; p < rom + length; p++)
-		sum += *p;
+	for (sum = 0; length; length--)
+		sum += *rom++;
 	return sum == 0;
 }
 

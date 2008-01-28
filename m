Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYA1Irg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYA1Irg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYA1Iqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:46:38 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:7085 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771AbYA1Iqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:46:36 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2008 08:45:45 +0000
Message-Id: <1201509949-3285-6-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201509949-3285-5-git-send-email-ijc@hellion.org.uk>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-3-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-4-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-5-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 5/9] x86: Unify strings in arch/x86/boot/compressed/misc_??.c
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a preference for the 64 bit version so use that on 32 bit and
drop the stray leading "."

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc_32.c |    4 ++--
 arch/x86/boot/compressed/misc_64.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index 5a0281c..a1979e3 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -377,8 +377,8 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long end,
 #endif
 
 	makecrc();
-	putstr("Uncompressing Linux... ");
+	putstr("\nDecompressing Linux... ");
 	gunzip();
-	putstr("Ok, booting the kernel.\n");
+	putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
index 8c1573b..355e31b 100644
--- a/arch/x86/boot/compressed/misc_64.c
+++ b/arch/x86/boot/compressed/misc_64.c
@@ -372,7 +372,7 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
 		error("Destination address too large");
 
 	makecrc();
-	putstr(".\nDecompressing Linux...");
+	putstr("\nDecompressing Linux... ");
 	gunzip();
 	putstr("done.\nBooting the kernel.\n");
 	return;
-- 
1.5.3.8


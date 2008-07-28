Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYG1Qrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYG1Qrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYG1Qqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:46:46 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33277 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYG1Qqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:46:42 -0400
X-BigFish: VPS12(zz1cddkzz10d3izzz32i68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0K4Q6LC-01-PPO-01
Message-ID: <20080728164447.569717192@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:13 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 02/11] [PATCH 02/11] x86: Moved Intel microcode patch loader declarations to seperate header file.
References: <20080728164411.490752571@amd.com>
Content-Disposition: inline;
	filename="0002-x86-Moved-Intel-microcode-patch-loader-declarations.patch"
X-OriginalArrivalTime: 28 Jul 2008 16:46:29.0106 (UTC) FILETIME=[7B82CD20:01C8F0D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel specific microcode declarations have been moved to a seperate header file.
There are no code changes to the code itself and no side effects to other parts.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c |    1 +
 include/asm-x86/microcode.h |   34 ++++++++++++++++++++++++++++++++++
 include/asm-x86/processor.h |   35 -----------------------------------
 3 files changed, 35 insertions(+), 35 deletions(-)
 create mode 100644 include/asm-x86/microcode.h

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 6994c75..0d654bd 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -93,6 +93,7 @@
 #include <asm/msr.h>
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <asm/microcode.h>
 
 MODULE_DESCRIPTION("Intel CPU (IA-32) Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
new file mode 100644
index 0000000..5a05568
--- /dev/null
+++ b/include/asm-x86/microcode.h
@@ -0,0 +1,34 @@
+struct microcode_header {
+	unsigned int            hdrver;
+	unsigned int            rev;
+	unsigned int            date;
+	unsigned int            sig;
+	unsigned int            cksum;
+	unsigned int            ldrver;
+	unsigned int            pf;
+	unsigned int            datasize;
+	unsigned int            totalsize;
+	unsigned int            reserved[3];
+};
+
+struct microcode {
+	struct microcode_header hdr;
+	unsigned int            bits[0];
+};
+
+typedef struct microcode          microcode_t;
+typedef struct microcode_header   microcode_header_t;
+
+/* microcode format is extended from prescott processors */
+struct extended_signature {
+	unsigned int            sig;
+	unsigned int            pf;
+	unsigned int            cksum;
+};
+
+struct extended_sigtable {
+	unsigned int            count;
+	unsigned int            cksum;
+	unsigned int            reserved[3];
+	struct extended_signature sigs[0];
+};
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 5f58da4..58a76f6 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -561,41 +561,6 @@ static inline void clear_in_cr4(unsigned long mask)
 	write_cr4(cr4);
 }
 
-struct microcode_header {
-	unsigned int		hdrver;
-	unsigned int		rev;
-	unsigned int		date;
-	unsigned int		sig;
-	unsigned int		cksum;
-	unsigned int		ldrver;
-	unsigned int		pf;
-	unsigned int		datasize;
-	unsigned int		totalsize;
-	unsigned int		reserved[3];
-};
-
-struct microcode {
-	struct microcode_header	hdr;
-	unsigned int		bits[0];
-};
-
-typedef struct microcode	microcode_t;
-typedef struct microcode_header	microcode_header_t;
-
-/* microcode format is extended from prescott processors */
-struct extended_signature {
-	unsigned int		sig;
-	unsigned int		pf;
-	unsigned int		cksum;
-};
-
-struct extended_sigtable {
-	unsigned int		count;
-	unsigned int		cksum;
-	unsigned int		reserved[3];
-	struct extended_signature sigs[0];
-};
-
 typedef struct {
 	unsigned long		seg;
 } mm_segment_t;
-- 
1.5.4.5





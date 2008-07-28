Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYG1QrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYG1QrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYG1Qqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:46:45 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:38341 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYG1Qql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:46:41 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 5,
X-WSS-ID: 0K4Q6LD-01-PPQ-01
Message-ID: <20080728164448.209009223@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:15 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 04/11] [PATCH 04/11] x86: Moved per CPU microcode structure declaration to header file.
References: <20080728164411.490752571@amd.com>
Content-Disposition: inline;
	filename="0004-x86-Moved-per-CPU-microcode-structure-declaration-t.patch"
X-OriginalArrivalTime: 28 Jul 2008 16:46:29.0199 (UTC) FILETIME=[7B90FDF0:01C8F0D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This structure will be later used by other modules as well and
needs therfore to be moved out to a header file.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c |    8 +-------
 include/asm-x86/microcode.h |    8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 74e6a77..4e7b2f6 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -125,13 +125,7 @@ static DEFINE_SPINLOCK(microcode_update_lock);
 /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
 static DEFINE_MUTEX(microcode_mutex);
 
-static struct ucode_cpu_info {
-	int valid;
-	unsigned int sig;
-	unsigned int pf;
-	unsigned int rev;
-	struct microcode *mc;
-} ucode_cpu_info[NR_CPUS];
+static struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 
 static void collect_cpu_info(int cpu_num)
 {
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 1519ef0..d34a1fc 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -29,3 +29,11 @@ struct extended_sigtable {
 	unsigned int            reserved[3];
 	struct extended_signature sigs[0];
 };
+
+struct ucode_cpu_info {
+	int valid;
+	unsigned int sig;
+	unsigned int pf;
+	unsigned int rev;
+	struct microcode *mc;
+};
-- 
1.5.4.5





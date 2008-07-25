Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbYGYQRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbYGYQRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYGYQRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:17:22 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:56317 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYGYQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:17:21 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K4KL8I-02-OZN-01
Message-ID: <20080725162002.543350440@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 25 Jul 2008 18:17:26 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 3/9] [PATCH 3/9] x86: Moved per CPU microcode structure declaration to header file.
References: <20080725161723.636932280@amd.com>
Content-Disposition: inline;
	filename="0003-x86-Moved-per-CPU-microcode-structure-declaration-t.patch"
X-OriginalArrivalTime: 25 Jul 2008 16:17:08.0526 (UTC) FILETIME=[E2E25CE0:01C8EE71]
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
index 406261a..d3bc0e8 100644
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





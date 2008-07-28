Return-Path: <linux-kernel-owner+w=401wt.eu-S1760021AbYG1Qtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbYG1Qtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbYG1Qqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:46:52 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33901 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbYG1Qqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:46:51 -0400
X-BigFish: VPS12(zz1cddkzz10d3izzz32i68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0K4Q6LL-01-PQ0-01
Message-ID: <20080728164449.112113362@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:20 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 09/11] [PATCH 09/11] x86: First step of refactoring, introducing microcode_ops.
References: <20080728164411.490752571@amd.com>
Content-Disposition: inline;
	filename="0009-x86-First-step-of-refactoring-introducing-microcod.patch"
X-OriginalArrivalTime: 28 Jul 2008 16:46:29.0778 (UTC) FILETIME=[7BE95720:01C8F0D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactoring with the goal of having one general module and separate
vendor specific modules that hook into the general one.

Microcode_ops is a function pointer structure in which vendor
specific modules will enter all functions that differ between
vendors and that need to be accessed from the general module.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 include/asm-x86/microcode.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 4e94172..9231c87 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -1,3 +1,16 @@
+struct microcode_ops {
+	long (*get_next_ucode)(void **mc, long offset);
+	long (*microcode_get_next_ucode)(void **mc, long offset);
+	int (*get_matching_microcode)(void *mc, int cpu);
+	int (*apply_microcode_check_cpu)(int cpu);
+	int (*microcode_sanity_check)(void *mc);
+	int (*cpu_request_microcode)(int cpu);
+	void (*collect_cpu_info)(int cpu_num);
+	void (*apply_microcode)(int cpu);
+	void (*microcode_fini_cpu)(int cpu);
+	void (*clear_patch)(void *data);
+};
+
 struct microcode_header_intel {
 	unsigned int            hdrver;
 	unsigned int            rev;
-- 
1.5.4.5





Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYGYQqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYGYQqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYGYQqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:46:11 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:50072 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYGYQqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:46:10 -0400
X-BigFish: VPS7(zz1cddkzz10d3izzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0K4KL8J-01-GGR-01
Message-ID: <20080725162003.224987320@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 25 Jul 2008 18:17:30 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 7/9] [PATCH 7/9] x86: First step of refactoring, introducing microcode_ops.
References: <20080725161723.636932280@amd.com>
Content-Disposition: inline;
	filename="0007-x86-First-step-of-refactoring-introducing-microcod.patch"
X-OriginalArrivalTime: 25 Jul 2008 16:17:08.0667 (UTC) FILETIME=[E2F7E0B0:01C8EE71]
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





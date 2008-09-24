Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYIXI7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYIXI7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYIXI7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:59:17 -0400
Received: from [165.204.77.10] ([165.204.77.10]:25908 "EHLO elemente.amd.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752363AbYIXI7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:59:16 -0400
Message-Id: <200809240955.m8O9tqMT017080@elemente.amd.com>
From: Peter Oruba <peter.oruba@amd.com>
Date: Wed, 24 Sep 2008 11:50:35 +0200
Subject: [PATCH] x86: Microcode patch loader bugfix
To: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected CPU vendor check condition for AMD microcode patch loader
initialization.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>



---
 arch/x86/kernel/microcode_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index ff031db..8db2eb5 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -450,7 +450,7 @@ static int __init microcode_init(void)
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();
-	else if (c->x86_vendor != X86_VENDOR_AMD)
+	else if (c->x86_vendor == X86_VENDOR_AMD)
 		microcode_ops = init_amd_microcode();
 
 	if (!microcode_ops) {
-- 
1.5.4.1


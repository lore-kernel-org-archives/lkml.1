Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYHAKtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYHAKtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 06:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbYHAKtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 06:49:40 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:42803 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYHAKtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 06:49:39 -0400
X-BigFish: VPS2(z78cMz1cddkzz10d3izzz32i8ah43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4X4Q0-02-QWQ-01
Message-ID: <20080801104754.604840263@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 1 Aug 2008 12:46:46 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Oruba <peter.oruba@amd.com>
Subject: [patch 2/2] [PATCH 2/2] x86: Fixed NULL function pointer dereference in AMD microcode patch loader.
References: <20080801104644.788786464@amd.com>
Content-Disposition: inline;
	filename="0002-x86-Fixed-NULL-function-pointer-dereference-in-AMD.patch"
X-OriginalArrivalTime: 01 Aug 2008 10:49:11.0067 (UTC) FILETIME=[3B18A6B0:01C8F3C4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dereference took place in code part responsible for manual installation
of microcode patches through /dev/cpu/microcode.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 39961bb..ad136ad 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -127,7 +127,8 @@ static int do_microcode_update(void)
 	old = current->cpus_allowed;
 
 	while ((cursor = microcode_ops->get_next_ucode(&new_mc, cursor)) > 0) {
-		error = microcode_ops->microcode_sanity_check(new_mc);
+		if (microcode_ops->microcode_sanity_check != NULL)
+			error = microcode_ops->microcode_sanity_check(new_mc);
 		if (error)
 			goto out;
 		/*
-- 
1.5.4.5





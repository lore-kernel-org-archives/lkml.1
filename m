Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYG2Pot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYG2Pot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYG2PoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:44:06 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:42500 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYG2PoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:44:03 -0400
X-BigFish: VPS7(zz1cddkzz10d3izzz32i43j)
X-WSS-ID: 0K4RYCZ-02-I2Q-01
Message-ID: <20080729154146.021513400@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 29 Jul 2008 17:41:07 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Oruba <peter.oruba@amd.com>
Subject: [patch 4/4] x86: Minor pointer type cast in AMD microcode patch loader.
References: <20080729154103.007575982@amd.com>
Content-Disposition: inline;
	filename="0004-x86-Minor-pointer-type-cast-in-AMD-microcode-patch.patch"
X-OriginalArrivalTime: 29 Jul 2008 15:43:49.0150 (UTC) FILETIME=[E4D0CBE0:01C8F191]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 2b98e6a..33b2a21 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -394,7 +394,8 @@ static int cpu_request_microcode_amd(int cpu)
 		return error;
 	}
 
-	buf_pos = buf = firmware->data;
+	buf_pos = (unsigned int *)firmware->data;
+	buf = (void *)firmware->data;
 	size = firmware->size;
 
 	if (buf_pos[0] != UCODE_MAGIC) {
-- 
1.5.4.5





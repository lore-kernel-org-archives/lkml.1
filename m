Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbZEQP62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbZEQP62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZEQP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:58:18 -0400
Received: from mx1.wp.pl ([212.77.101.5]:37287 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZEQP6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:58:17 -0400
Date: Sun, 17 May 2009 18:04:24 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: cpufreq@vger.kernel.org
Cc: LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Fix VIA C3 Longhaul v2 identification
Message-Id: <20090517180424.6836b46d.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [gWN0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

An identification of the Longhaul versions (v1, v2 and v3) selects only
v1 or v3 version. There is a special case for late Samuel2 and early Ezra cores
which support the Longhaul v2 but the Longhaul v1 is selected. These cores
are described in the comment as supporting the Longhaul v2.

Select the Longhaul v2 for cores which support it.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
--- 
I don't know if selecting the Longhaul v1 for these cores was a typo or done or 
purpose. I cannot find any reference to this part of the code.

I have tested the change and it enables the Longhaul v2 on my Samuel2 core
but voltage change is not supported by my motherboard (PCChips something).
The voltage range is detected as a single value.

diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index ce2ed3e..cabd2fa 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -813,7 +813,7 @@ static int __init longhaul_cpu_init(struct cpufreq_policy *policy)
 			memcpy(eblcr, samuel2_eblcr, sizeof(samuel2_eblcr));
 			break;
 		case 1 ... 15:
-			longhaul_version = TYPE_LONGHAUL_V1;
+			longhaul_version = TYPE_LONGHAUL_V2;
 			if (c->x86_mask < 8) {
 				cpu_model = CPU_SAMUEL2;
 				cpuname = "C3 'Samuel 2' [C5B]";

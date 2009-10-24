Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbZJXPIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbZJXPIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 11:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZJXPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 11:08:13 -0400
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:22159 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZJXPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 11:08:12 -0400
Date: Sat, 24 Oct 2009 17:25:38 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: cpufreq@vger.kernel.org
Cc: LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH] longhaul: select Longhaul version 2 for capable CPUs
Message-Id: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: c2c0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

There is a typo in the longhaul detection code so only Longhaul v1 or Longhaul v3
is selected. The Longhaul v2 is not selected even for CPUs which are capable of.

Tested on PCChips Giga Pro board. Frequency changes work and the Longhaul v2
detects that the board is not capable of changing CPU voltage.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---
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


---------------------------------------------------------------
Zobacz jak pracuje sie na wysokosciach.
Kliknij >>> http://link.interia.pl/f2384


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758995AbYDJVb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbYDJVb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYDJVbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:31:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:5321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbYDJVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=BHx/rB5wBrmc0Wm17HwmgF/TdPwJu7MMTJAVn8/fYriUwVAEYLbp2JjZHf6QpsrDkYuaFI33y6Mhrb+ABGvX3cXbu2LT8O1aXqKN9nQW69xnBlMQ3u//Ol7xcaGSny8fn0Gk2WPqaG/5xq0xNFjtfXwyhOpoASqwXLTWa19o4bE=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: set_cyc2ns_scale() remove tsc_now and ns_now
Date: Thu, 10 Apr 2008 23:31:11 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804102331.11815.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Both are unused and the functions rdtscll() and __cycles_2_ns() don't have
side-effects.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---
 arch/x86/kernel/tsc_32.c |    4 ----
 arch/x86/kernel/tsc_64.c |    4 ----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 82602d7..0406b80 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -84,7 +84,6 @@ DEFINE_PER_CPU(unsigned long, cyc2ns);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long long tsc_now, ns_now;
 	unsigned long flags, *scale;
 
 	local_irq_save(flags);
@@ -92,9 +91,6 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 
 	scale = &per_cpu(cyc2ns, cpu);
 
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
 	if (cpu_khz)
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
 
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index f08e1ea..5246036 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -44,7 +44,6 @@ DEFINE_PER_CPU(unsigned long, cyc2ns);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long long tsc_now, ns_now;
 	unsigned long flags, *scale;
 
 	local_irq_save(flags);
@@ -52,9 +51,6 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 
 	scale = &per_cpu(cyc2ns, cpu);
 
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
 	if (cpu_khz)
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
 
-- 
1.5.3.3


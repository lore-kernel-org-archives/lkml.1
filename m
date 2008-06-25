Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYFYTxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYFYTxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYFYTxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:53:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:37832 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750752AbYFYTxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:53:37 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX1+qII8yaiKq/Ol1LbuE2HT24HpXd0jDt40z47gZt8
	QWQKlj6qTPfFNo
From: Bernd Schubert <bernd-schubert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: x86: enable pat on amd athlon mode=6
Date: Wed, 25 Jun 2008 21:53:35 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806252153.35675.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on my AthlonXP 1700 PAT works fine (I tested it several days). Please accept one of the patches below, I don't know which you refer.


Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>

Patch to enable PAT specifically on model=6

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..61a5aa5 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -57,6 +57,8 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
 			return;
+		if (c->x86 == 0x6)
+			return;
 		break;
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))


Or maybe PAT on all system >=6 is suitable?


diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..f12c413 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -55,7 +55,7 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
+		if (c->x86 >= 0x6 && c->x86 <= 0x11)
 			return;
 		break;
 	case X86_VENDOR_INTEL:


Thanks,
Bernd

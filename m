Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbYEVVyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbYEVVyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbYEVVyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:54:13 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:47026 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755391AbYEVVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:54:12 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: Set pic_mode only if local apic code is present
Date: Fri, 23 May 2008 01:54:44 +0400
Message-ID: <20080522215444.1697.15900.stgit@thinkpad>
In-Reply-To: <alpine.LFD.1.10.0805222343430.3295@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0805222343430.3295@apollo.tec.linutronix.de>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/mpparse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 59f051d..e61523a 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -609,7 +609,7 @@ static void __init __get_smp_config(unsigned early)
 
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
 	       mpf->mpf_specification);
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 	if (mpf->mpf_feature2 & (1 << 7)) {
 		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
 		pic_mode = 1;


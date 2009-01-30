Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZA3Dbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZA3Dbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZA3Db2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:31:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:46702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZA3Db2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:31:28 -0500
Message-ID: <4982743C.5000200@kernel.org>
Date: Thu, 29 Jan 2009 19:30:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix compiling with 64bit with def_to_bigsmp
References: <49827414.2020908@kernel.org>
In-Reply-To: <49827414.2020908@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fic compiling

only need to do cut off with 32bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1000,7 +1000,7 @@ static int __init smp_sanity_check(unsig
 {
 	preempt_disable();
 
-#ifndef CONFIG_X86_BIGSMP
+#if !defined(CONFIG_X86_BIGSMP) && defined(CONFIG_X86_32)
 	if (def_to_bigsmp && nr_cpu_ids > 8) {
 		unsigned int cpu;
 		unsigned nr;

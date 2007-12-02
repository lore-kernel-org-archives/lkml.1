Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXLBAnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXLBAnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXLBAm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:42:56 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60146 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753502AbXLBAmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:42:55 -0500
Date: Sun, 2 Dec 2007 01:42:48 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Chris Clayton <chris2553@googlemail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 intel_cacheinfo.c section fix
Message-ID: <20071202004248.GF15974@stusta.de>
References: <200711291419.49261.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711291419.49261.chris2553@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_cache_attributes() must be __cpuinit since it calls the
__cpuinit cache_remove_shared_cpu_map().

This patch fixes the following section mismatch reported by
Chris Clayton:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x90b6): Section mismatch: reference to .init.text:cache_remove_shared_cpu_map (between 'free_cache_attributes' and 'show_level')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
afa32c098aaa39826ec6c71e641908ea12287e48 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 9921b01..606fe4d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -497,7 +497,7 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
 static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
 #endif
 
-static void free_cache_attributes(unsigned int cpu)
+static void __cpuinit free_cache_attributes(unsigned int cpu)
 {
 	int i;
 


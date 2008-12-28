Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYL1HNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYL1HNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 02:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYL1HM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 02:12:56 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:14202 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYL1HMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 02:12:55 -0500
Message-ID: <495726DA.80301@larces.uece.br>
Date: Sun, 28 Dec 2008 04:12:26 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: mark get_cpu_leaves() with __cpuinit annotation
References: <495725B0.30501@larces.uece.br>
In-Reply-To: <495725B0.30501@larces.uece.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, now including LKML as well. Sorry.
Sergio.

----

 x86: mark get_cpu_leaves() with __cpuinit annotation

 Impact: fix section mismatch 

 Commit b2bb85549134c005e997e5a7ed303bda6a1ae738 introduced 
 get_cpu_leaves(), which references __cpuinit cpuid4_cache_lookup().
 Mark get_cpu_leaves() with a __cpuinit annotation.

 Signed-off-by: Sergio Luis <sergio@larces.uece.br>
 Cc: Mike Travis <travis@sgi.com>
 Cc: Rusty Russell <rusty@rustcorp.com.au>
 Cc: Ingo Molnar <mingo@elte.hu>
 Cc: Oleg Nesterov <oleg@tv-sign.ru>
 ---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1d76dd9..96f3945 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -536,7 +536,7 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
-static void get_cpu_leaves(void *_retval)
+static void __cpuinit get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();
 


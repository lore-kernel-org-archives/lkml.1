Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZF1VFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZF1VFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZF1VFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:05:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:45366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZF1VFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:05:01 -0400
Message-ID: <4A47DAF3.2090400@kernel.org>
Date: Sun, 28 Jun 2009 14:04:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/perf_count: change intel_pmu and amd_pmu to initdata
References: <4A47DAB1.3090707@kernel.org>
In-Reply-To: <4A47DAB1.3090707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it is assigned to x86_pmu aka copied to x86_pmu
so change it to __initdata

[Impact: cleanup]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -1351,7 +1351,7 @@ static __read_mostly struct notifier_blo
 	.priority		= 1
 };
 
-static struct x86_pmu intel_pmu = {
+static __initdata struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
 	.disable_all		= intel_pmu_disable_all,
@@ -1371,7 +1371,7 @@ static struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 };
 
-static struct x86_pmu amd_pmu = {
+static __initdata struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= amd_pmu_handle_irq,
 	.disable_all		= amd_pmu_disable_all,

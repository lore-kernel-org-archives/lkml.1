Return-Path: <linux-kernel-owner+w=401wt.eu-S1762030AbYGOCh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030AbYGOCh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761322AbYGOCed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:33 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:30196 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761283AbYGOCeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:31 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 09/14] [SH] Populate cpu_enabled_map
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       Paul Mundt <lethal@linux-sh.org>
Date: Mon, 14 Jul 2008 20:34:30 -0600
Message-ID: <20080715023430.2528.48009.stgit@blender.achiang>
In-Reply-To: <20080715023344.2528.1836.stgit@blender.achiang>
References: <20080715023344.2528.1836.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the cpu_enabled_map correctly.

Note that this patch does not actually make any decisions based
on the contents of the map.

However, as the map is presented via sysfs in:

	/sys/devices/system/cpu/

It should be populated correctly.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---

 arch/sh/kernel/smp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 5d039d1..b91fdfa 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -60,6 +60,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 
 #ifndef CONFIG_HOTPLUG_CPU
 	cpu_present_map = cpu_possible_map;
+	cpu_enabled_map = cpu_possible_map;
 #endif
 }
 


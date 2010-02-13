Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0BMCvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:51:50 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64087 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0BMCuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:50:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 12 Feb 2010 18:49:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 7/8] x86: use num_processors for possible cpus
In-reply-to: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1266029390-30907-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some systems that have disable cpus entries because same
  BIOS will support 2 sockets and 4 sockets and more at
  same time, BIOS just leave some disable entries, but
  those system do not support cpu hotplug. we don't need
  treat disabled_cpus as hotplug cpus.
so we can make nr_cpu_ids smaller and save more space
  (pcpu data allocations), and could make some systems run
  with logical flat instead of physical flat apic mode

-v2: change to black list instead
-v3: just remove that, and the one use possible_cpus= directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/smpboot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index da99eef..51ec4b6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1194,7 +1194,6 @@ early_param("possible_cpus", _setup_possible_cpus);
  * - Ashok Raj
  *
  * Three ways to find out the number of additional hotplug CPUs:
- * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
  * - The user can overwrite it with possible_cpus=NUM
  * - Otherwise don't reserve additional CPUs.
  * We do this because additional CPUs waste a lot of memory.
@@ -1209,7 +1208,7 @@ __init void prefill_possible_map(void)
 		num_processors = 1;
 
 	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
+		possible = num_processors;
 	else
 		possible = setup_possible_cpus;
 
-- 
1.6.4.2


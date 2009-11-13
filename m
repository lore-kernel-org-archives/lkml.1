Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZKMUaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZKMUaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZKMUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:30:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbZKMUaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:30:20 -0500
Date: Fri, 13 Nov 2009 15:30:00 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [X86] Minimise printk spew from per-vendor init code.
Message-ID: <20091113203000.GA19160@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the default case where the kernel supports all CPU vendors,
we currently print out a bunch of not useful messages on every system.

32bit:
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC

64bit:
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls


Given that "what CPUs does the kernel support" isn't useful for
the "support everything" case, we can suppress these printk's.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..617a29f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -656,6 +656,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 void __init early_cpu_init(void)
 {
+#ifdef PROCESSOR_SELECT
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
@@ -676,7 +677,7 @@ void __init early_cpu_init(void)
 				cpudev->c_ident[j]);
 		}
 	}
-
+#endif
 	early_identify_cpu(&boot_cpu_data);
 }
 

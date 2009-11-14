Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbZKNAeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbZKNAeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbZKNAeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:34:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:56701 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561AbZKNAeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:34:03 -0500
Date: Sat, 14 Nov 2009 00:33:35 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davej@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
In-Reply-To: <20091113203000.GA19160@redhat.com>
References: <20091113203000.GA19160@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Minimise printk spew from per-vendor init code
Message-ID: <tip-0388423dba2217b4e5b6c61690b0506d13b25a49@git.kernel.org>
Git-Commit-ID: 0388423dba2217b4e5b6c61690b0506d13b25a49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0388423dba2217b4e5b6c61690b0506d13b25a49
Gitweb:     http://git.kernel.org/tip/0388423dba2217b4e5b6c61690b0506d13b25a49
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Fri, 13 Nov 2009 15:30:00 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 01:18:05 +0100

x86: Minimise printk spew from per-vendor init code

In the default case where the kernel supports all CPU vendors,
we currently print out a bunch of not useful messages on every
system.

32-bit:
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC

64-bit:
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls

Given that "what CPUs does the kernel support" isn't useful for
the "support everything" case, we can suppress these printk's.

Signed-off-by: Dave Jones <davej@redhat.com>
LKML-Reference: <20091113203000.GA19160@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
 

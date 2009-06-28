Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZF1Hks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZF1Hks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 03:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZF1Hkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 03:40:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:48307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbZF1Hkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 03:40:40 -0400
Date: Sun, 28 Jun 2009 07:39:55 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Cc: grundler@parisc-linux.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, mikpe@it.uu.se, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, tglx@linutronix.de, mikpe@it.uu.se
In-Reply-To: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
Subject: [tip:x86/urgent] Revert "x86: cap iomem_resource to addressable physical memory"
Message-ID: <tip-ff8a4bae459a9b6455504127fcb78fdbc8e50e4c@git.kernel.org>
Git-Commit-ID: ff8a4bae459a9b6455504127fcb78fdbc8e50e4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 28 Jun 2009 07:40:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff8a4bae459a9b6455504127fcb78fdbc8e50e4c
Gitweb:     http://git.kernel.org/tip/ff8a4bae459a9b6455504127fcb78fdbc8e50e4c
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sat, 27 Jun 2009 12:22:27 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 28 Jun 2009 09:38:47 +0200

Revert "x86: cap iomem_resource to addressable physical memory"

This reverts commit 95ee14e4379c5e19c0897c872350570402014742.
Mikael Petterson <mikepe@it.uu.se> reported that at least one of his
systems will not boot as a result.  We have ruled out the detection
algorithm malfunctioning, so it is not a matter of producing the
incorrect bitmasks; rather, something in the application of them
fails.

Revert the commit until we can root cause and correct this problem.

-stable team: this means the underlying commit should be rejected.

Reported-and-isolated-by: Mikael Petterson <mikpe@it.uu.se>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
Cc: stable@kernel.org
Cc: Grant Grundler <grundler@parisc-linux.org>


---
 arch/x86/kernel/cpu/common.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b26d4d..f1961c0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -848,9 +848,6 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	numa_add_cpu(smp_processor_id());
 #endif
-
-	/* Cap the iomem address space to what is addressable on all CPUs */
-	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
 }
 
 #ifdef CONFIG_X86_64

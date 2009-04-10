Return-Path: <linux-kernel-owner+w=401wt.eu-S937581AbZDJMiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937581AbZDJMiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZDJMim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:38:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:45833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbZDJMil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:38:41 -0400
Date: Fri, 10 Apr 2009 12:36:33 GMT
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, andreas.herrmann3@amd.com,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, akpm@linux-foundation.org,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409130510.GG31527@alberich.amd.com>
References: <20090409130510.GG31527@alberich.amd.com>
Subject: [tip:x86/cpu] x86: cacheinfo: use L3 cache index disable feature only for CPUs that support it
Message-ID: <tip-bda869c614c937c318547c3ee1d65a316b693c21@git.kernel.org>
Git-Commit-ID: bda869c614c937c318547c3ee1d65a316b693c21
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:36:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bda869c614c937c318547c3ee1d65a316b693c21
Gitweb:     http://git.kernel.org/tip/bda869c614c937c318547c3ee1d65a316b693c21
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 9 Apr 2009 15:05:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 14:21:40 +0200

x86: cacheinfo: use L3 cache index disable feature only for CPUs that support it

AMD family 0x11 CPU doesn't support the feature.

Some AMD family 0x10 CPUs do not support it or have an erratum, see
erratum #382 in "Revision Guide for AMD Family 10h Processors, 41322
Rev. 3.40 February 2009".

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090409130510.GG31527@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 483eda9..7240126 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -291,6 +291,14 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
 	if (index < 3)
 		return;
+
+	if (boot_cpu_data.x86 == 0x11)
+		return;
+
+	/* see erratum #382 */
+	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x8))
+		return;
+
 	this_leaf->can_disable = 1;
 }
 

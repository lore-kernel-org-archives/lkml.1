Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbZKJNWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbZKJNWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZKJNWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:22:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:34020 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZKJNWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:22:22 -0500
Date: Tue, 10 Nov 2009 13:22:03 GMT
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091110110825.GI30802@alberich.amd.com>
References: <20091110110825.GI30802@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86: ucode-amd: Don't warn when no ucode is available for a CPU revision
Message-ID: <tip-14c569425a0ae12cbeed72fdb8ebe78c48455dfd@git.kernel.org>
Git-Commit-ID: 14c569425a0ae12cbeed72fdb8ebe78c48455dfd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14c569425a0ae12cbeed72fdb8ebe78c48455dfd
Gitweb:     http://git.kernel.org/tip/14c569425a0ae12cbeed72fdb8ebe78c48455dfd
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Tue, 10 Nov 2009 12:08:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 12:15:49 +0100

x86: ucode-amd: Don't warn when no ucode is available for a CPU revision

There is no point in warning when there is no ucode available
for a specific CPU revision. Currently the container-file, which
provides the AMD ucode patches for OS load, contains only a few
ucode patches.

It's already clearly indicated by the printed patch_level
whenever new ucode was available and an update happened. So the
warning message is of no help but rather annoying on systems
with many CPUs.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: dimm <dmitry.adamushko@gmail.com>
LKML-Reference: <20091110110825.GI30802@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_amd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 75538f6..9f13324 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -105,11 +105,8 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 		i++;
 	}
 
-	if (!equiv_cpu_id) {
-		printk(KERN_WARNING "microcode: CPU%d: cpu revision "
-		       "not listed in equivalent cpu table\n", cpu);
+	if (!equiv_cpu_id)
 		return 0;
-	}
 
 	if (mc_header->processor_rev_id != equiv_cpu_id)
 		return 0;

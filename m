Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZFLQ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZFLQ0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764629AbZFLQY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:24:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39059 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764019AbZFLQY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 05/27] Blackfin: include the cpu compiled version in /proc/cpuinfo
Date: Fri, 12 Jun 2009 12:24:23 -0400
Message-Id: <1244823885-22410-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Since the compiled-for cpu revision can be significant, include it in the
cpuinfo output along side the cpu revision we're currently running on.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 80447f9..f5f516e 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -1098,7 +1098,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 			CPUID, bfin_cpuid());
 
 	seq_printf(m, "model name\t: ADSP-%s %lu(MHz CCLK) %lu(MHz SCLK) (%s)\n"
-		"stepping\t: %d\n",
+		"stepping\t: %d ",
 		cpu, cclk/1000000, sclk/1000000,
 #ifdef CONFIG_MPU
 		"mpu on",
@@ -1107,7 +1107,16 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 #endif
 		revid);
 
-	seq_printf(m, "cpu MHz\t\t: %lu.%03lu/%lu.%03lu\n",
+	if (bfin_revid() != bfin_compiled_revid()) {
+		if (bfin_compiled_revid() == -1)
+			seq_printf(m, "(Compiled for Rev none)");
+		else if (bfin_compiled_revid() == 0xffff)
+			seq_printf(m, "(Compiled for Rev any)");
+		else
+			seq_printf(m, "(Compiled for Rev %d)", bfin_compiled_revid());
+	}
+
+	seq_printf(m, "\ncpu MHz\t\t: %lu.%03lu/%lu.%03lu\n",
 		cclk/1000000, cclk%1000000,
 		sclk/1000000, sclk%1000000);
 	seq_printf(m, "bogomips\t: %lu.%02lu\n"
-- 
1.6.3.1


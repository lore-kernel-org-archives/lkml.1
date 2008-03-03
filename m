Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbYCCR3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbYCCR3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbYCCRQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760003AbYCCRQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:01 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 20/52] provide hlt_works function.
Date: Mon,  3 Mar 2008 14:12:48 -0300
Message-Id: <1204564400-17636-21-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-20-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86_64, hlt always work. in i386, we'll query the cpuinfo associated
with this cpu

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 9054734..8bec23c 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -144,6 +144,15 @@ DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
 #define current_cpu_data	boot_cpu_data
 #endif
 
+static inline int hlt_works(int cpu)
+{
+#ifdef CONFIG_X86_32
+	return cpu_data(cpu).hlt_works_ok;
+#else
+	return 1;
+#endif
+}
+
 #define cache_line_size()	(boot_cpu_data.x86_cache_alignment)
 
 extern void cpu_detect(struct cpuinfo_x86 *c);
-- 
1.5.0.6


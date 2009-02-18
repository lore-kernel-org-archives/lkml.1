Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZBRMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZBRMF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZBRMFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:50696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZBRMFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:18 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] module: reorder module pcpu related functions
Date: Wed, 18 Feb 2009 21:04:29 +0900
Message-Id: <1234958676-27618-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:04:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Move percpu_modinit() upwards.  This is to ease further changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/module.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index d54a63e..84773e6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -482,21 +482,6 @@ static void percpu_modfree(void *freeme)
 	}
 }
 
-static unsigned int find_pcpusec(Elf_Ehdr *hdr,
-				 Elf_Shdr *sechdrs,
-				 const char *secstrings)
-{
-	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
-}
-
-static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
-}
-
 static int percpu_modinit(void)
 {
 	pcpu_num_used = 2;
@@ -515,7 +500,24 @@ static int percpu_modinit(void)
 	return 0;
 }
 __initcall(percpu_modinit);
+
+static unsigned int find_pcpusec(Elf_Ehdr *hdr,
+				 Elf_Shdr *sechdrs,
+				 const char *secstrings)
+{
+	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
+}
+
+static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
+}
+
 #else /* ... !CONFIG_SMP */
+
 static inline void *percpu_modalloc(unsigned long size, unsigned long align,
 				    const char *name)
 {
@@ -537,6 +539,7 @@ static inline void percpu_modcopy(void *pcpudst, const void *src,
 	/* pcpusec should be 0, and size of that section should be 0. */
 	BUG_ON(size != 0);
 }
+
 #endif /* CONFIG_SMP */
 
 #define MODINFO_ATTR(field)	\
-- 
1.6.0.2


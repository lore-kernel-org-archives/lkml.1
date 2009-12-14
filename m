Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZLNAFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZLNAFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZLNAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:04:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbZLMX6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:32 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, mingo@redhat.com,
       torvalds@linux-foundation.org, hpa@zytor.com
Subject: [PATCH 1/1] Constify struct microcode_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:10 +0100
Message-Id: <68a93103b8686f50b0bc0cd5681f14036e5b594e.1260663001.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663001.git.re.emese@gmail.com>
References: <cover.1260663001.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/x86/include/asm/microcode.h  |   22 +++++++++++-----------
 arch/x86/kernel/microcode_amd.c   |    4 ++--
 arch/x86/kernel/microcode_core.c  |    2 +-
 arch/x86/kernel/microcode_intel.c |    4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c24ca9a..f0b99e6 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -12,15 +12,15 @@ struct device;
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
 
 struct microcode_ops {
-	void (*init)(struct device *device);
-	void (*fini)(void);
-	enum ucode_state (*request_microcode_user) (int cpu,
+	void (* const init)(struct device *device);
+	void (* const fini)(void);
+	enum ucode_state (* const request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
-	enum ucode_state (*request_microcode_fw) (int cpu,
+	enum ucode_state (* const request_microcode_fw) (int cpu,
 				struct device *device);
 
-	void (*microcode_fini_cpu) (int cpu);
+	void (* const microcode_fini_cpu) (int cpu);
 
 	/*
 	 * The generic 'microcode_core' part guarantees that
@@ -28,8 +28,8 @@ struct microcode_ops {
 	 * are being called.
 	 * See also the "Synchronization" section in microcode_core.c.
 	 */
-	int (*apply_microcode) (int cpu);
-	int (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
+	int (* const apply_microcode) (int cpu);
+	int (* const collect_cpu_info) (int cpu, struct cpu_signature *csig);
 };
 
 struct ucode_cpu_info {
@@ -40,18 +40,18 @@ struct ucode_cpu_info {
 extern struct ucode_cpu_info ucode_cpu_info[];
 
 #ifdef CONFIG_MICROCODE_INTEL
-extern struct microcode_ops * __init init_intel_microcode(void);
+extern const struct microcode_ops * __init init_intel_microcode(void);
 #else
-static inline struct microcode_ops * __init init_intel_microcode(void)
+static inline const struct microcode_ops * __init init_intel_microcode(void)
 {
 	return NULL;
 }
 #endif /* CONFIG_MICROCODE_INTEL */
 
 #ifdef CONFIG_MICROCODE_AMD
-extern struct microcode_ops * __init init_amd_microcode(void);
+extern const struct microcode_ops * __init init_amd_microcode(void);
 #else
-static inline struct microcode_ops * __init init_amd_microcode(void)
+static inline const struct microcode_ops * __init init_amd_microcode(void)
 {
 	return NULL;
 }
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 37542b6..6b5ecf5 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -347,7 +347,7 @@ void fini_microcode_amd(void)
 	release_firmware(firmware);
 }
 
-static struct microcode_ops microcode_amd_ops = {
+static const struct microcode_ops microcode_amd_ops = {
 	.init				  = init_microcode_amd,
 	.fini				  = fini_microcode_amd,
 	.request_microcode_user           = request_microcode_user,
@@ -357,7 +357,7 @@ static struct microcode_ops microcode_amd_ops = {
 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
 };
 
-struct microcode_ops * __init init_amd_microcode(void)
+const struct microcode_ops * __init init_amd_microcode(void)
 {
 	return &microcode_amd_ops;
 }
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 844c02c..0e53e96 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -92,7 +92,7 @@ MODULE_LICENSE("GPL");
 
 #define MICROCODE_VERSION	"2.00"
 
-static struct microcode_ops	*microcode_ops;
+static const struct microcode_ops	*microcode_ops;
 
 /*
  * Synchronization.
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index ebd193e..cdcde3c 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -453,7 +453,7 @@ static void microcode_fini_cpu(int cpu)
 	uci->mc = NULL;
 }
 
-static struct microcode_ops microcode_intel_ops = {
+static const struct microcode_ops microcode_intel_ops = {
 	.request_microcode_user		  = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
@@ -461,7 +461,7 @@ static struct microcode_ops microcode_intel_ops = {
 	.microcode_fini_cpu               = microcode_fini_cpu,
 };
 
-struct microcode_ops * __init init_intel_microcode(void)
+const struct microcode_ops * __init init_intel_microcode(void)
 {
 	return &microcode_intel_ops;
 }
-- 
1.6.5.3


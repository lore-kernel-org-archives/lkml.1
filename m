Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYG1QtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYG1QtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYG1Qqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:46:51 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59368 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYG1Qqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:46:49 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4Q6LD-01-PPR-01
Message-ID: <20080728164447.874445939@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:14 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 03/11] [PATCH 03/11] x86: Typedef removal.
References: <20080728164411.490752571@amd.com>
Content-Disposition: inline; filename="0003-x86-Typedef-removal.patch"
X-OriginalArrivalTime: 28 Jul 2008 16:46:29.0199 (UTC) FILETIME=[7B90FDF0:01C8F0D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed typedefs. No functional changes to the code.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode.c |   24 ++++++++++++------------
 include/asm-x86/microcode.h |    3 ---
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 0d654bd..74e6a77 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -102,17 +102,17 @@ MODULE_LICENSE("GPL");
 #define MICROCODE_VERSION 	"1.14a"
 
 #define DEFAULT_UCODE_DATASIZE 	(2000) 	  /* 2000 bytes */
-#define MC_HEADER_SIZE		(sizeof (microcode_header_t))  	  /* 48 bytes */
+#define MC_HEADER_SIZE		(sizeof (struct microcode_header))  	  /* 48 bytes */
 #define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE) /* 2048 bytes */
 #define EXT_HEADER_SIZE		(sizeof (struct extended_sigtable)) /* 20 bytes */
 #define EXT_SIGNATURE_SIZE	(sizeof (struct extended_signature)) /* 12 bytes */
 #define DWSIZE			(sizeof (u32))
 #define get_totalsize(mc) \
-	(((microcode_t *)mc)->hdr.totalsize ? \
-	 ((microcode_t *)mc)->hdr.totalsize : DEFAULT_UCODE_TOTALSIZE)
+	(((struct microcode *)mc)->hdr.totalsize ? \
+	 ((struct microcode *)mc)->hdr.totalsize : DEFAULT_UCODE_TOTALSIZE)
 #define get_datasize(mc) \
-	(((microcode_t *)mc)->hdr.datasize ? \
-	 ((microcode_t *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
+	(((struct microcode *)mc)->hdr.datasize ? \
+	 ((struct microcode *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
 
 #define sigmatch(s1, s2, p1, p2) \
 	(((s1) == (s2)) && (((p1) & (p2)) || (((p1) == 0) && ((p2) == 0))))
@@ -130,7 +130,7 @@ static struct ucode_cpu_info {
 	unsigned int sig;
 	unsigned int pf;
 	unsigned int rev;
-	microcode_t *mc;
+	struct microcode *mc;
 } ucode_cpu_info[NR_CPUS];
 
 static void collect_cpu_info(int cpu_num)
@@ -171,7 +171,7 @@ static void collect_cpu_info(int cpu_num)
 }
 
 static inline int microcode_update_match(int cpu_num,
-	microcode_header_t *mc_header, int sig, int pf)
+	struct microcode_header *mc_header, int sig, int pf)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 
@@ -183,7 +183,7 @@ static inline int microcode_update_match(int cpu_num,
 
 static int microcode_sanity_check(void *mc)
 {
-	microcode_header_t *mc_header = mc;
+	struct microcode_header *mc_header = mc;
 	struct extended_sigtable *ext_header = NULL;
 	struct extended_signature *ext_sig;
 	unsigned long total_size, data_size, ext_table_size;
@@ -268,7 +268,7 @@ static int microcode_sanity_check(void *mc)
 static int get_maching_microcode(void *mc, int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	microcode_header_t *mc_header = mc;
+	struct microcode_header *mc_header = mc;
 	struct extended_sigtable *ext_header;
 	unsigned long total_size = get_totalsize(mc_header);
 	int ext_sigcount, i;
@@ -355,7 +355,7 @@ static unsigned int user_buffer_size;	/* it's size */
 
 static long get_next_ucode(void **mc, long offset)
 {
-	microcode_header_t mc_header;
+	struct microcode_header mc_header;
 	unsigned long total_size;
 
 	/* No more data */
@@ -497,13 +497,13 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 static long get_next_ucode_from_buffer(void **mc, const u8 *buf,
 	unsigned long size, long offset)
 {
-	microcode_header_t *mc_header;
+	struct microcode_header *mc_header;
 	unsigned long total_size;
 
 	/* No more data */
 	if (offset >= size)
 		return 0;
-	mc_header = (microcode_header_t *)(buf + offset);
+	mc_header = (struct microcode_header *)(buf + offset);
 	total_size = get_totalsize(mc_header);
 
 	if (offset + total_size > size) {
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 5a05568..1519ef0 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -16,9 +16,6 @@ struct microcode {
 	unsigned int            bits[0];
 };
 
-typedef struct microcode          microcode_t;
-typedef struct microcode_header   microcode_header_t;
-
 /* microcode format is extended from prescott processors */
 struct extended_signature {
 	unsigned int            sig;
-- 
1.5.4.5





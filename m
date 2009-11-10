Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZKJLJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZKJLJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbZKJLJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:09:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:63146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbZKJLJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nWBATA0HaxHhxtvz3eT0SopsOO8ywxpO4sT79JgMlJtx940nKyOn6mMiEdrMgTp2gK
         rHorhNmiTuMNcpIPiKW4GII8H8HJVB4T8Dzu2l4DPknzW5dwt+PGkThBTKc3OtP669Vh
         jJmUIGVgcJ8s2Y03sMpU9YSaAFroUVGQc4uBM=
Date: Tue, 10 Nov 2009 12:09:20 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, dimm <dmitry.adamushko@gmail.com>
Subject: [PATCH 3/3] x86, ucode-amd: printk(KERN_* to pr_* conversion
Message-ID: <20091110110920.GJ30802@alberich.amd.com>
References: <20091110110601.GG30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110110601.GG30802@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 9f13324..26e33bd 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -78,12 +78,12 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		printk(KERN_WARNING "microcode: CPU%d: AMD CPU family 0x%x not "
-		       "supported\n", cpu, c->x86);
+		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
+			   "supported\n", cpu, c->x86);
 		return -1;
 	}
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
-	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
+	pr_info("microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
 }
 
@@ -113,7 +113,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
-		printk(KERN_ERR "microcode: CPU%d: loading of chipset "
+		pr_err(KERN_ERR "microcode: CPU%d: loading of chipset "
 		       "specific code not yet supported\n", cpu);
 		return 0;
 	}
@@ -143,14 +143,12 @@ static int apply_microcode_amd(int cpu)
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
-		printk(KERN_ERR "microcode: CPU%d: update failed "
+		pr_err("microcode: CPU%d: update failed "
 		       "(for patch_level=0x%x)\n", cpu, mc_amd->hdr.patch_id);
 		return -1;
 	}
 
-	printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n",
-	       cpu, rev);
-
+	pr_info("microcode: CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
 
 	return 0;
@@ -173,7 +171,7 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 		return NULL;
 
 	if (section_hdr[0] != UCODE_UCODE_TYPE) {
-		printk(KERN_ERR "microcode: error: invalid type field in "
+		pr_err("microcode: error: invalid type field in "
 		       "container file section header\n");
 		return NULL;
 	}
@@ -181,7 +179,7 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		printk(KERN_ERR "microcode: error: size mismatch\n");
+		pr_err("microcode: error: size mismatch\n");
 		return NULL;
 	}
 
@@ -210,15 +208,14 @@ static int install_equiv_cpu_table(const u8 *buf)
 	size = buf_pos[2];
 
 	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
-		printk(KERN_ERR "microcode: error: invalid type field in "
+		pr_err("microcode: error: invalid type field in "
 		       "container file section header\n");
 		return 0;
 	}
 
 	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
 	if (!equiv_cpu_table) {
-		printk(KERN_ERR "microcode: failed to allocate "
-		       "equivalent CPU table\n");
+		pr_err("microcode: failed to allocate equivalent CPU table\n");
 		return 0;
 	}
 
@@ -251,8 +248,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
-		printk(KERN_ERR "microcode: failed to create "
-		       "equivalent cpu table\n");
+		pr_err("microcode: failed to create equivalent cpu table\n");
 		return UCODE_ERROR;
 	}
 
@@ -306,7 +302,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		return UCODE_NFOUND;
 
 	if (*(u32 *)firmware->data != UCODE_MAGIC) {
-		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
+		pr_err("microcode: invalid UCODE_MAGIC (0x%08x)\n",
 		       *(u32 *)firmware->data);
 		return UCODE_ERROR;
 	}
@@ -319,8 +315,8 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 static enum ucode_state
 request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	printk(KERN_INFO "microcode: AMD microcode update via "
-	       "/dev/cpu/microcode not supported\n");
+	pr_info("microcode: AMD microcode update via "
+		"/dev/cpu/microcode not supported\n");
 	return UCODE_ERROR;
 }
 
@@ -336,7 +332,7 @@ void init_microcode_amd(struct device *device)
 {
 	const char *fw_name = "amd-ucode/microcode_amd.bin";
 	if (request_firmware(&firmware, fw_name, device))
-		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
+		pr_err("microcode: failed to load file %s\n", fw_name);
 }
 
 void fini_microcode_amd(void)
-- 
1.6.5.2


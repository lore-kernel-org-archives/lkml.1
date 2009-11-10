Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbZKJFP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbZKJFP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZKJFP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:15:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:56513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZKJFP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:15:57 -0500
Date: Tue, 10 Nov 2009 05:15:37 GMT
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, herrmann.der.user@googlemail.com,
       tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, herrmann.der.user@googlemail.com,
       tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20091029134742.GD30802@alberich.amd.com>
References: <20091029134742.GD30802@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, amd-ucode: Remove needless log messages
Message-ID: <tip-6e18da75c28b592594fd632cf3e6eb09d3d078de@git.kernel.org>
Git-Commit-ID: 6e18da75c28b592594fd632cf3e6eb09d3d078de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e18da75c28b592594fd632cf3e6eb09d3d078de
Gitweb:     http://git.kernel.org/tip/6e18da75c28b592594fd632cf3e6eb09d3d078de
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Thu, 29 Oct 2009 14:47:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 05:49:28 +0100

x86, amd-ucode: Remove needless log messages

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20091029134742.GD30802@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_amd.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index f4c538b..c043534 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -109,12 +109,8 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 		return 0;
 	}
 
-	if (mc_header->processor_rev_id != equiv_cpu_id) {
-		printk(KERN_ERR	"microcode: CPU%d: patch mismatch "
-		       "(processor_rev_id: %x, equiv_cpu_id: %x)\n",
-		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
+	if (mc_header->processor_rev_id != equiv_cpu_id)
 		return 0;
-	}
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
@@ -185,9 +181,6 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 
 	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
-	printk(KERN_DEBUG "microcode: size %u, total_size %u\n",
-	       size, total_size);
-
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
 		printk(KERN_ERR "microcode: error: size mismatch\n");
 		return NULL;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbYFYOop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbYFYOop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbYFYOhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:37:55 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:54198 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729AbYFYOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:37:54 -0400
Message-Id: <20080625143613.917426201@de.ibm.com>
References: <20080625143459.100139455@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Jun 2008 16:35:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/21] Cleanup kprobes printk messages.
Content-Disposition: inline; filename=809-printk-kprobes.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/kprobes.c       |    4 +---
 arch/s390/kernel/machine_kexec.c |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

Index: quilt-2.6/arch/s390/kernel/kprobes.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/kprobes.c
+++ quilt-2.6/arch/s390/kernel/kprobes.c
@@ -41,10 +41,8 @@ int __kprobes arch_prepare_kprobe(struct
 	if (is_prohibited_opcode((kprobe_opcode_t *) p->addr))
 		return -EINVAL;
 
-	if ((unsigned long)p->addr & 0x01) {
-		printk("Attempt to register kprobe at an unaligned address\n");
+	if ((unsigned long)p->addr & 0x01)
 		return -EINVAL;
-		}
 
 	/* Use the get_insn_slot() facility for correctness */
 	if (!(p->ainsn.insn = get_insn_slot()))
Index: quilt-2.6/arch/s390/kernel/machine_kexec.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/machine_kexec.c
+++ quilt-2.6/arch/s390/kernel/machine_kexec.c
@@ -52,7 +52,6 @@ void machine_kexec_cleanup(struct kimage
 
 void machine_shutdown(void)
 {
-	printk(KERN_INFO "kexec: machine_shutdown called\n");
 }
 
 void machine_kexec(struct kimage *image)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


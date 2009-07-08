Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZGHSEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZGHSEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZGHSD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:03:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58518 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626AbZGHSD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HhNLcMwtKxbkkApvAWXQJB4rd51qYBR8uvowCCdp4RNN/IQbnenQ5zzPLnBVPCNT/a
         bLnJi3+UGnFXL6v6fTlF3KxQGZGz/3IXwL22JCXlJ9iFLifWQyPXVFBcQxoa/nOQHlrw
         ssKOPF512rbSxNE/HMmGAE7rwu8jK0AjR1anM=
Date: Wed, 8 Jul 2009 22:03:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -tip] x86,idt_descr -- use NR_VECTORS instead of hardcoded
	number
Message-ID: <20090708180353.GH5301@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review

 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/traps.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/common.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6.git/arch/x86/kernel/cpu/common.c
@@ -982,7 +982,7 @@ static __init int setup_disablecpuid(cha
 __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
-struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
+struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
Index: linux-2.6.git/arch/x86/kernel/traps.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps.c
+++ linux-2.6.git/arch/x86/kernel/traps.c
@@ -76,7 +76,7 @@ char ignore_fpu_irq;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-gate_desc idt_table[256]
+gate_desc idt_table[NR_VECTORS]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 #endif
 

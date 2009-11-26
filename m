Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbZKZA6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbZKZA6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZKZA6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:58:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49967 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZKZA6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:58:03 -0500
Date: Thu, 26 Nov 2009 11:58:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andreas Schwab <schwab@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the m68knommu tree with the m68k tree
Message-Id: <20091126115806.c53684f5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the m68knommu tree got a conflict in
arch/m68k/include/asm/ptrace.h between commit
63c361b65f6540043c4baabf1a044a45c7465858 ("m68k: use generic code for
ptrace requests") from the m68k tree and commit
03a03164e8084b810e9f92906a51232d63bac72c ("m68knommu: define
arch_has_single_step() and friends") from the m68knommu tree.

These mostly add the same stuff but not quite :-(

I have done a fixup (see below) and can carry it as necessary.  Please
check the result.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/m68k/include/asm/ptrace.h
index eef9309,beb2091..0000000
--- a/arch/m68k/include/asm/ptrace.h
+++ b/arch/m68k/include/asm/ptrace.h
@@@ -86,14 -84,15 +86,18 @@@ struct switch_stack 
  extern void show_regs(struct pt_regs *);
  
  /*
 - * These are defined as per linux/ptrace.h.
 + * These are defined as per linux/ptrace.h, which see.
   */
+ struct task_struct;
+ 
 -#ifndef CONFIG_MMU
 -#define	arch_has_single_step()	(1)
 +#define arch_has_single_step()	(1)
  extern void user_enable_single_step(struct task_struct *);
  extern void user_disable_single_step(struct task_struct *);
 +
++#ifdef CONFIG_MMU
 +#define arch_has_block_step()	(1)
 +extern void user_enable_block_step(struct task_struct *);
+ #endif
  
  #endif /* __KERNEL__ */
  #endif /* __ASSEMBLY__ */

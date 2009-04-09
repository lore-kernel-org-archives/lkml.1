Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbZDIGNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbZDIGNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZDIGNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:13:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:38158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbZDIGNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:13:14 -0400
Date: Thu, 9 Apr 2009 06:12:29 GMT
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, davem@davemloft.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20090409151722.c8eabb56.sfr@canb.auug.org.au>
References: <20090409151722.c8eabb56.sfr@canb.auug.org.au>
Subject: [tip:core/futexes] sparc64: extend TI_RESTART_BLOCK space by 8 bytes
Message-ID: <tip-d2de688891909b148efe83a6fc9520a9cd6015f0@git.kernel.org>
Git-Commit-ID: d2de688891909b148efe83a6fc9520a9cd6015f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 06:12:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2de688891909b148efe83a6fc9520a9cd6015f0
Gitweb:     http://git.kernel.org/tip/d2de688891909b148efe83a6fc9520a9cd6015f0
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Thu, 9 Apr 2009 15:17:22 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 08:09:50 +0200

sparc64: extend TI_RESTART_BLOCK space by 8 bytes

Impact: build fix

Today's linux-next build (sparc64 defconfig) failed like this:

  arch/sparc/kernel/built-in.o: In function `trap_init':
  (.init.text+0x4): undefined reference to `thread_info_offsets_are_bolixed_dave'

Caused by commit 52400ba946759af28442dee6265c5c0180ac7122 ("futex: add
requeue_pi functionality") (from the tip-core tree) which changed the
size of struct restart_block.

Shift TI_KUNA_REGS and TI_KUNA_INSN up by 8 bytes to make space for the
larger restart block.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: "David S. Miller" <davem@davemloft.net>
Cc: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <20090409151722.c8eabb56.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/sparc/include/asm/thread_info_64.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 639ac80..6586572 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -102,8 +102,8 @@ struct thread_info {
 #define TI_KERN_CNTD1	0x00000488
 #define TI_PCR		0x00000490
 #define TI_RESTART_BLOCK 0x00000498
-#define TI_KUNA_REGS	0x000004c0
-#define TI_KUNA_INSN	0x000004c8
+#define TI_KUNA_REGS	0x000004c8
+#define TI_KUNA_INSN	0x000004d0
 #define TI_FPREGS	0x00000500
 
 /* We embed this in the uppermost byte of thread_info->flags */

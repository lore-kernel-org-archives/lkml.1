Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZLNAIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZLNAIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZLMX6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34342 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbZLMX6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:07 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, benh@kernel.crashing.org,
       torvalds@linux-foundation.org, jkosina@suse.cz
Subject: [PATCH 8/8] Constify struct kgdb_arch for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:56 +0100
Message-Id: <7939cb1570bc773d009c8aeaec5765f773f990ec.1260662999.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662999.git.re.emese@gmail.com>
References: <cover.1260662999.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/powerpc/kernel/kgdb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index b6bd1ea..1e433f7 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -126,7 +126,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 	if (kgdb_handle_exception(0, SIGTRAP, 0, regs) != 0)
 		return 0;
 
-	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
+	if (*(u32 *) (regs->nip) == *(const u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
 		regs->nip += 4;
 
 	return 1;
@@ -353,7 +353,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 /*
  * Global data
  */
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	.gdb_bpt_instr = {0x7d, 0x82, 0x10, 0x08},
 };
 
-- 
1.6.5.3


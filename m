Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYDRQyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYDRQyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYDRQy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:54:27 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:20424 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYDRQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GQrSSvIRPRX/RXS4zwsuYMTXW0veyOrkGTWtTGq5ALG6QW4eCWv5fxt4uXhCtat7SXxIxVpsznZzO4PlLJFqfMcbAywlcZI4exLCh+/rmpeb5mjhtlsTpcSyg1y4pwstR/aXdR9rvhZTQuTOrFcMHoznfUVt85ArLw3q6v0vxDw=
Subject: [PATCH] x86: kgdb build fix
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 09:54:38 -0700
Message-Id: <1208537678.17196.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TF_MASK is no longer defined, use X86_EFLAGS_TF.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
In current -linus tree.

 arch/x86/kernel/kgdb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8c7e555..24362ec 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -375,12 +375,12 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 		newPC = linux_regs->ip;
 
 		/* clear the trace bit */
-		linux_regs->flags &= ~TF_MASK;
+		linux_regs->flags &= ~X86_EFLAGS_TF;
 		atomic_set(&kgdb_cpu_doing_single_step, -1);
 
 		/* set the trace bit if we're stepping */
 		if (remcomInBuffer[0] == 's') {
-			linux_regs->flags |= TF_MASK;
+			linux_regs->flags |= X86_EFLAGS_TF;
 			kgdb_single_step = 1;
 			if (kgdb_contthread) {
 				atomic_set(&kgdb_cpu_doing_single_step,
-- 
1.5.5.144.g3e42




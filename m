Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbXHVMfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbXHVMfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760969AbXHVMdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:33:11 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:24385 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760678AbXHVMc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:32:58 -0400
Message-Id: <20070822123643.486708718@de.ibm.com>
References: <20070822123603.501231302@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 14:36:10 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 07/10] disassembler: fix b2 opcodes like srst, bsg, and others
Content-Disposition: inline; filename=007-disasm.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The instruction table for b2 opcodes was missing an opfrag value
for the cpya instruction. All instructions specified after cpya
were not considered by the disassembler. The fix is simple and
obvious - add the opfrag field to the cpya instruction. 

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/kernel/dis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/dis.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/dis.c
+++ quilt-2.6/arch/s390/kernel/dis.c
@@ -577,7 +577,7 @@ static struct insn opcode_b2[] = {
 	{ "esta", 0x4a, INSTR_RRE_RR },
 	{ "lura", 0x4b, INSTR_RRE_RR },
 	{ "tar", 0x4c, INSTR_RRE_AR },
-	{ "cpya", INSTR_RRE_AA },
+	{ "cpya", 0x4d, INSTR_RRE_AA },
 	{ "sar", 0x4e, INSTR_RRE_AR },
 	{ "ear", 0x4f, INSTR_RRE_RA },
 	{ "csp", 0x50, INSTR_RRE_RR },

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


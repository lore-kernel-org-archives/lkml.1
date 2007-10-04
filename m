Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbXJDLdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbXJDLdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbXJDL2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:28:50 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:25469 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbXJDL22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:28 -0400
Message-Id: <20071004112829.773479156@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:25 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 19/34] disassembler: fix output for insns with 6 operands.
Content-Disposition: inline; filename=019-dis-bug.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The termination condition of the loop that prints the operands of
an instruction doesn't stop after the maximum of 6 operands.
It continues with the operands of the next instruction format
instead which create really long lines.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/dis.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/dis.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/dis.c
+++ quilt-2.6/arch/s390/kernel/dis.c
@@ -1162,6 +1162,7 @@ static int print_insn(char *buffer, unsi
 	unsigned int value;
 	char separator;
 	char *ptr;
+	int i;
 
 	ptr = buffer;
 	insn = find_insn(code);
@@ -1169,7 +1170,8 @@ static int print_insn(char *buffer, unsi
 		ptr += sprintf(ptr, "%.5s\t", insn->name);
 		/* Extract the operands. */
 		separator = 0;
-		for (ops = formats[insn->format] + 1; *ops != 0; ops++) {
+		for (ops = formats[insn->format] + 1, i = 0;
+		     *ops != 0 && i < 6; ops++, i++) {
 			operand = operands + *ops;
 			value = extract_operand(code, operand);
 			if ((operand->flags & OPERAND_INDEX)  && value == 0)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


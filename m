Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYE2NC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYE2NC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYE2NBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:01:10 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:64636 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYE2NBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:01:05 -0400
Message-Id: <20080529125730.886412108@de.ibm.com>
References: <20080529125501.196123527@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 14:55:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 11/11] disassembler: fix idte instruction format.
Content-Disposition: inline; filename=011-idte-dis.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The correct instruction format of idte is "idte r1,r3,r2" with
r1 at bit 24, r3 at bit 16 and r2 at bit 28. 

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/dis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/dis.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/dis.c
+++ quilt-2.6/arch/s390/kernel/dis.c
@@ -208,7 +208,7 @@ static const unsigned char formats[][7] 
 	[INSTR_RRF_F0FF]  = { 0xff, F_16,F_24,F_28,0,0,0 },    /* e.g. madbr */
 	[INSTR_RRF_FUFF]  = { 0xff, F_24,F_16,F_28,U4_20,0,0 },/* e.g. didbr */
 	[INSTR_RRF_RURR]  = { 0xff, R_24,R_28,R_16,U4_20,0,0 },/* e.g. .insn */
-	[INSTR_RRF_R0RR]  = { 0xff, R_24,R_28,R_16,0,0,0 },    /* e.g. idte  */
+	[INSTR_RRF_R0RR]  = { 0xff, R_24,R_16,R_28,0,0,0 },    /* e.g. idte  */
 	[INSTR_RRF_U0FF]  = { 0xff, F_24,U4_16,F_28,0,0,0 },   /* e.g. fixr  */
 	[INSTR_RRF_U0RF]  = { 0xff, R_24,U4_16,F_28,0,0,0 },   /* e.g. cfebr */
 	[INSTR_RRF_M0RR]  = { 0xff, R_24,R_28,M_16,0,0,0 },    /* e.g. sske  */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


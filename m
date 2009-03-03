Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZCCP40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZCCP40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZCCP4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:56:20 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:50075 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZCCP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:56:20 -0500
From: Dan Smith <danms@us.ibm.com>
To: containers@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 1/3] s390: Expose a constant for the number of words representing the CRs
Date: Tue,  3 Mar 2009 10:56:02 -0500
Message-Id: <1236095764-19325-2-git-send-email-danms@us.ibm.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use this value in the checkpoint/restart code and would like to
have a constant instead of a magic '3'.

Signed-off-by: Dan Smith <danms@us.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/include/asm/ptrace.h   |    2 ++
 arch/s390/kernel/compat_ptrace.h |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 5396f9f..d5b0781 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -172,6 +172,8 @@
 #define NUM_CRS		16
 #define NUM_ACRS	16
 
+#define NUM_CR_WORDS	3
+
 #define FPR_SIZE	8
 #define FPC_SIZE	4
 #define FPC_PAD_SIZE	4 /* gcc insists on aligning the fpregs */
diff --git a/arch/s390/kernel/compat_ptrace.h b/arch/s390/kernel/compat_ptrace.h
index a2be3a9..123dd66 100644
--- a/arch/s390/kernel/compat_ptrace.h
+++ b/arch/s390/kernel/compat_ptrace.h
@@ -1,10 +1,11 @@
 #ifndef _PTRACE32_H
 #define _PTRACE32_H
 
+#include <asm/ptrace.h>    /* needed for NUM_CR_WORDS */
 #include "compat_linux.h"  /* needed for psw_compat_t */
 
 typedef struct {
-	__u32 cr[3];
+	__u32 cr[NUM_CR_WORDS];
 } per_cr_words32;
 
 typedef struct {
-- 
1.6.1


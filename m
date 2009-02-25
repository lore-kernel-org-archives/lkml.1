Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbZBYPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbZBYPSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760241AbZBYPJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:22 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:58604 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722AbZBYPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:45 -0500
Message-Id: <20090225150839.584679865@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:07:07 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 45/46] ftrace/mcount: fix kernel stack backchain
Content-Disposition: inline; filename=144-ftrace-mcount.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

With packed stack the backchain is at a different location.
Just use __SF_BACKCHAIN as an offset to store the backchain.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/mcount.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/mcount.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/mcount.S
+++ quilt-2.6/arch/s390/kernel/mcount.S
@@ -5,6 +5,8 @@
  *
  */
 
+#include <asm/asm-offsets.h>
+
 #ifndef CONFIG_64BIT
 .globl _mcount
 _mcount:
@@ -14,7 +16,7 @@ _mcount:
 	ahi	%r15,-96
 	l	%r3,100(%r15)
 	la	%r2,0(%r14)
-	st	%r1,0(%r15)
+	st	%r1,__SF_BACKCHAIN(%r15)
 	la	%r3,0(%r3)
 	bras	%r14,0f
 	.long	ftrace_trace_function
@@ -38,7 +40,7 @@ _mcount:
 	stg	%r14,112(%r15)
 	lgr	%r1,%r15
 	aghi	%r15,-160
-	stg	%r1,0(%r15)
+	stg	%r1,__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r14
 	lg	%r3,168(%r15)
 	larl	%r14,ftrace_trace_function

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZEVQjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZEVQjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZEVQjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:39:31 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:44605 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbZEVQja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:39:30 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 11:39:24 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221139.26941.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found in the bit-rot for 32-bit, x86, Uni-processor builds:

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index f6aa18e..3c790ef 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -35,7 +35,7 @@
                "661:\n\tlock; "

 #else /* ! CONFIG_SMP */
-#define LOCK_PREFIX ""
+#define LOCK_PREFIX "\n\tlock; "
 #endif

 /* This must be included *after* the definition of LOCK_PREFIX */

Submitted: M. S. Zick

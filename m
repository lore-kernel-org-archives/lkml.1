Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYBEPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYBEPlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYBEPjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:39:23 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:40340 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYBEPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:39:16 -0500
Message-Id: <20080205153913.447241337@de.ibm.com>
References: <20080205153835.337897404@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Feb 2008 16:38:45 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/18] Define GENERIC_LOCKBREAK.
Content-Disposition: inline; filename=010-lockbreak.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix compile error:

  CC      arch/s390/kernel/asm-offsets.s
In file included from 
arch/s390/kernel/asm-offsets.c:7:
include/linux/sched.h: In function 'spin_needbreak':
include/linux/sched.h:1931: error: implicit declaration of function '__raw_spin_is_contended'
make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

Index: quilt-2.6/arch/s390/Kconfig
===================================================================
--- quilt-2.6.orig/arch/s390/Kconfig
+++ quilt-2.6/arch/s390/Kconfig
@@ -47,6 +47,11 @@ config NO_IOMEM
 config NO_DMA
 	def_bool y
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 mainmenu "Linux Kernel Configuration"
 
 config S390

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


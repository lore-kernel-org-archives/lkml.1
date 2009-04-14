Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZDNNzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZDNNzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZDNNxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:53:54 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:59077 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbZDNNxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:53:49 -0400
Message-Id: <20090414135346.995857296@de.ibm.com>
References: <20090414135327.576111185@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 15:53:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/14] call nmi_enter/nmi_exit on machine checks
Content-Disposition: inline; filename=003-nmi_enter.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

nmi_enter/nmi_exit includes the lockdep calls and various
other calls which were missing so far.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/nmi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/nmi.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/nmi.c
+++ quilt-2.6/arch/s390/kernel/nmi.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/hardirq.h>
 #include <linux/time.h>
 #include <linux/module.h>
 #include <asm/lowcore.h>
@@ -253,7 +254,7 @@ void notrace s390_do_machine_check(struc
 	struct mci *mci;
 	int umode;
 
-	lockdep_off();
+	nmi_enter();
 	s390_idle_check();
 
 	mci = (struct mci *) &S390_lowcore.mcck_interruption_code;
@@ -363,7 +364,7 @@ void notrace s390_do_machine_check(struc
 		mcck->warning = 1;
 		set_thread_flag(TIF_MCCK_PENDING);
 	}
-	lockdep_on();
+	nmi_exit();
 }
 
 static int __init machine_check_init(void)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


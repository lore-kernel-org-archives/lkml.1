Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbZBYPWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbZBYPWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760522AbZBYPJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:48 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51709 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbZBYPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:09:20 -0500
Message-Id: <20090225150836.091189939@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:06:54 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 32/46] kernel: Disable switch_amode by default
Content-Disposition: inline; filename=131-amode-default.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

Disable switch_amode by default because pagetable walk on pre z9
hardware has negative performance impact.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/setup.c |    4 ----
 1 file changed, 4 deletions(-)

Index: quilt-2.6/arch/s390/kernel/setup.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/setup.c
+++ quilt-2.6/arch/s390/kernel/setup.c
@@ -301,11 +301,7 @@ static int __init early_parse_mem(char *
 early_param("mem", early_parse_mem);
 
 #ifdef CONFIG_S390_SWITCH_AMODE
-#ifdef CONFIG_PGSTE
-unsigned int switch_amode = 1;
-#else
 unsigned int switch_amode = 0;
-#endif
 EXPORT_SYMBOL_GPL(switch_amode);
 
 static int set_amode_and_uaccess(unsigned long user_amode,

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


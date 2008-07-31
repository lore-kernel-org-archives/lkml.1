Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYGaMk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYGaMk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYGaMk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:40:29 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:52473 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbYGaMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:40:27 -0400
Message-Id: <20080731123932.621722615@de.ibm.com>
References: <20080731123004.868574766@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 14:30:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/6] stp: fix section mismatch warning.
Content-Disposition: inline; filename=101-stp-section.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix these two (false positive) warnings by adding an __init annoation:

WARNING: vmlinux.o(.text+0x7e6a): Section mismatch in reference from the function stp_reset() to the function .init.text:__alloc_bootmem()
The function stp_reset() references
the function __init __alloc_bootmem().
This is often because stp_reset lacks a __init
annotation or the annotation of __alloc_bootmem is wrong.

WARNING: vmlinux.o(.text+0x7ece): Section mismatch in reference from the function stp_reset() to the function .init.text:free_bootmem()
The function stp_reset() references
the function __init free_bootmem().
This is often because stp_reset lacks a __init
annotation or the annotation of free_bootmem is wrong.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/time.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/time.c
+++ quilt-2.6/arch/s390/kernel/time.c
@@ -1348,7 +1348,7 @@ early_param("stp", early_parse_stp);
 /*
  * Reset STP attachment.
  */
-static void stp_reset(void)
+static void __init stp_reset(void)
 {
 	int rc;
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


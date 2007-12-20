Return-Path: <linux-kernel-owner+w=401wt.eu-S965432AbXLTPdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965432AbXLTPdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934063AbXLTPWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:08 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:44549 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbXLTPVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:14 -0500
Message-Id: <20071220152112.434264083@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:20:08 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 43/47] Move NOTES and BUG_TABLE.
Content-Disposition: inline; filename=142-linker-script.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Move the NOTES and BUG_TABLE section in the linker script to the
read-only sections right after the text section.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/vmlinux.lds.S |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: quilt-2.6/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/vmlinux.lds.S
+++ quilt-2.6/arch/s390/kernel/vmlinux.lds.S
@@ -17,6 +17,12 @@ ENTRY(_start)
 jiffies = jiffies_64;
 #endif
 
+PHDRS {
+	text PT_LOAD FLAGS(5);	/* R_E */
+	data PT_LOAD FLAGS(7);	/* RWE */
+	note PT_NOTE FLAGS(0);	/* ___ */
+}
+
 SECTIONS
 {
 	. = 0x00000000;
@@ -33,6 +39,9 @@ SECTIONS
 
 	_etext = .;		/* End of text section */
 
+	NOTES :text :note
+	BUG_TABLE :text
+
 	RODATA
 
 #ifdef CONFIG_SHARED_KERNEL
@@ -49,9 +58,6 @@ SECTIONS
 		__stop___ex_table = .;
 	}
 
-	NOTES
-	BUG_TABLE
-
 	.data : {		/* Data */
 		DATA_DATA
 		CONSTRUCTORS

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


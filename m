Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbXEMMJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbXEMMJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXEMMJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:09:50 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:33931 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188AbXEMMJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=SliHGKf1xWXIFS5X1gFX8DxCL2yYU4Tg7jgua4Yv6D8LQ39OjmDTIcBsfELa9STV5rGNljmOJz5T4iF8OP0Bxq2nCI+tbg7EU6m5f78VVw3DBw3fStE2KFeen7Dnp156LmYIdxGJRp+Nd3LKdCN6pUhir7xZTqIRdxolQOlAo7g=
Date: Sun, 13 May 2007 22:09:41 +1000
From: Andrew Hendry <andrew.hendry@gmail.com>
To: James.Bottomley@steeleye.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mca: mca_pentium_flag no longer used
Message-Id: <20070513220941.8ff811ae.andrew.hendry@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks James, hopefully have the mailer fixed now. 


The check for mca_pentium_flag was removed long ago.
This cleans up the flag and documentation.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

diff -uprN -X dontdiff linux-2.6.21-vanilla/arch/i386/kernel/setup.c linux-2.6.21/arch/i386/kernel/setup.c
--- linux-2.6.21-vanilla/arch/i386/kernel/setup.c	2007-05-06 10:27:39.000000000 +1000
+++ linux-2.6.21/arch/i386/kernel/setup.c	2007-05-06 11:35:03.000000000 +1000
@@ -91,7 +91,6 @@ EXPORT_SYMBOL(machine_id);
 #endif
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
-unsigned int mca_pentium_flag;
 
 /* Boot loader ID as an integer, for the benefit of proc_dointvec */
 int bootloader_type;
diff -uprN -X dontdiff linux-2.6.21-vanilla/Documentation/kernel-parameters.txt linux-2.6.21/Documentation/kernel-parameters.txt
--- linux-2.6.21-vanilla/Documentation/kernel-parameters.txt	2007-05-06 10:27:37.000000000 +1000
+++ linux-2.6.21/Documentation/kernel-parameters.txt	2007-05-06 11:39:27.000000000 +1000
@@ -894,8 +894,6 @@ and is between 256 and 4096 characters. 
 			[SCSI] Maximum number of LUNs received.
 			Should be between 1 and 16384.
 
-	mca-pentium	[BUGS=IA-32]
-
 	mcatest=	[IA-64]
 
 	mcd=		[HW,CD]
diff -uprN -X dontdiff linux-2.6.21-vanilla/include/asm-i386/bugs.h linux-2.6.21/include/asm-i386/bugs.h
--- linux-2.6.21-vanilla/include/asm-i386/bugs.h	2007-05-06 10:31:04.000000000 +1000
+++ linux-2.6.21/include/asm-i386/bugs.h	2007-05-06 11:35:39.000000000 +1000
@@ -31,14 +31,6 @@ static int __init no_halt(char *s)
 
 __setup("no-hlt", no_halt);
 
-static int __init mca_pentium(char *s)
-{
-	mca_pentium_flag = 1;
-	return 1;
-}
-
-__setup("mca-pentium", mca_pentium);
-
 static int __init no_387(char *s)
 {
 	boot_cpu_data.hard_math = 0;
diff -uprN -X dontdiff linux-2.6.21-vanilla/include/asm-i386/processor.h linux-2.6.21/include/asm-i386/processor.h
--- linux-2.6.21-vanilla/include/asm-i386/processor.h	2007-05-06 10:31:05.000000000 +1000
+++ linux-2.6.21/include/asm-i386/processor.h	2007-05-06 11:35:19.000000000 +1000
@@ -264,7 +264,6 @@ others may find it useful. */
 extern unsigned int machine_id;
 extern unsigned int machine_submodel_id;
 extern unsigned int BIOS_revision;
-extern unsigned int mca_pentium_flag;
 
 /* Boot loader type from the setup header */
 extern int bootloader_type;

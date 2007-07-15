Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbXGOGnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbXGOGnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 02:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXGOGnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 02:43:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2944 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbXGOGnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 02:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=pe1UhcNELGd/I/fvD12hJn/7p8Nt6Idvn2z4gN5vKm4rsGVRxMjFJjqClNnq2Hh+E/qgvRtrPAwGzczllDhMA2+n9BvHSHscMK178WSLouHs0uTj/FA1EpWwZNoNfTUg/FV5eYTy4BuTfVEtFhHDnRiLvUu1nak8kTwJPMtwTw4=
Date: Sun, 15 Jul 2007 16:43:33 +1000
From: Andrew Hendry <andrew.hendry@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, jejb@steeleye.com,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] MCA: removed unused mca_pentium_flag
Message-ID: <20070715164333.74198c7a@jed>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The check for mca_pentium_flag was removed long ago.
This cleans up the flag and documentation.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

diff -uprN -X dontdiff a/arch/i386/kernel/cpu/bugs.c
b/arch/i386/kernel/cpu/bugs.c --- a/arch/i386/kernel/cpu/bugs.c
2007-07-15 12:04:50.000000000 +1000 +++
b/arch/i386/kernel/cpu/bugs.c	2007-07-15 12:01:46.000000000
+1000 @@ -25,14 +25,6 @@ static int __init no_halt(char *s) 
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
diff -uprN -X dontdiff a/arch/i386/kernel/setup.c
b/arch/i386/kernel/setup.c --- a/arch/i386/kernel/setup.c
2007-07-15 12:09:31.000000000 +1000 +++
b/arch/i386/kernel/setup.c	2007-07-15 11:57:17.000000000 +1000
@@ -91,7 +91,6 @@ EXPORT_SYMBOL(machine_id); #endif
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
-unsigned int mca_pentium_flag;
 
 /* Boot loader ID as an integer, for the benefit of proc_dointvec */
 int bootloader_type;
diff -uprN -X dontdiff a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt ---
a/Documentation/kernel-parameters.txt	2007-07-15
12:04:49.000000000 +1000 +++
b/Documentation/kernel-parameters.txt	2007-07-15
11:58:04.000000000 +1000 @@ -963,8 +963,6 @@ and is between 256 and
4096 characters. [SCSI] Maximum number of LUNs received. Should be
between 1 and 16384. 
-	mca-pentium	[BUGS=IA-32]
-
 	mcatest=	[IA-64]
 
 	mcd=		[HW,CD]
diff -uprN -X dontdiff a/Documentation/mca.txt b/Documentation/mca.txt
--- a/Documentation/mca.txt	2007-07-15 12:04:49.000000000 +1000
+++ b/Documentation/mca.txt	2007-07-15 11:59:12.000000000 +1000
@@ -213,13 +213,6 @@ detect the guilty device, but it's prett
 persistent problem (on some model 70 or 80s, they occur every couple
 shell commands), the CONFIG_IGNORE_NMI flag will take care of that.
 
-Various Pentium machines have had serious problems with the FPU test in
-bugs.h.  Basically, the machine hangs after the HLT test.  This occurs,
-as far as we know, on the Pentium-equipped 85s, 95s, and some PC
Servers. -The PCI/MCA PC 750s are fine as far as I can tell.  The
``mca-pentium'' -boot-prompt flag will disable the FPU bug check if
this is a problem -with your machine.
-
 The model 80 has a raft of problems that are just too weird and unique
 to get into here.  Some people have no trouble while others have
nothing but problems.  I'd suspect some problems are related to the age
of the diff -uprN -X dontdiff a/include/asm-i386/processor.h
b/include/asm-i386/processor.h ---
a/include/asm-i386/processor.h	2007-07-15 12:09:23.000000000
+1000 +++ b/include/asm-i386/processor.h	2007-07-15
12:00:45.000000000 +1000 @@ -211,7 +211,6 @@ others may find it useful.
*/ extern unsigned int machine_id; extern unsigned int
machine_submodel_id; extern unsigned int BIOS_revision;
-extern unsigned int mca_pentium_flag;
 
 /* Boot loader type from the setup header */
 extern int bootloader_type;

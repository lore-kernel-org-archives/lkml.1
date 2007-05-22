Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbXEVXrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbXEVXrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbXEVXrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:47:46 -0400
Received: from rwcrmhc13.comcast.net ([204.127.192.83]:36567 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbXEVXrp (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:47:45 -0400
Subject: [PATCH] 2.6.21-rt6 genapic
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <Linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Tue, 22 May 2007 16:47:38 -0700
Message-Id: <1179877658.25500.62.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add declaration for setup_apic_routing

This duplicates the declaration from i386 to x86_64 in the header.

The code, in genapic.c is shared between i386/x86_64.

Steven was trying to clean up that mess a while back, and this adds to
it.

In any case this gets compiling with
-Werror-implicit-function-declaration

Sven

Index: linux-2.6.21/arch/i386/kernel/acpi/boot.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/acpi/boot.c
+++ linux-2.6.21/arch/i386/kernel/acpi/boot.c
@@ -35,6 +35,7 @@
 #include <linux/ioport.h>
 
 #include <asm/pgtable.h>
+#include <asm/genapic.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 #include <asm/io.h>
Index: linux-2.6.21/arch/x86_64/kernel/mpparse.c
===================================================================
--- linux-2.6.21.orig/arch/x86_64/kernel/mpparse.c
+++ linux-2.6.21/arch/x86_64/kernel/mpparse.c
@@ -30,6 +30,7 @@
 #include <asm/io_apic.h>
 #include <asm/proto.h>
 #include <asm/acpi.h>
+#include <asm/genapic.h>
 
 /* Have we found an MP table */
 int smp_found_config;
Index: linux-2.6.21/include/asm-x86_64/genapic.h
===================================================================
--- linux-2.6.21.orig/include/asm-x86_64/genapic.h
+++ linux-2.6.21/include/asm-x86_64/genapic.h
@@ -29,6 +29,7 @@ struct genapic {
 	unsigned int (*phys_pkg_id)(int index_msb);
 };
 
+void setup_apic_routing(void);
 
 extern struct genapic *genapic;
 


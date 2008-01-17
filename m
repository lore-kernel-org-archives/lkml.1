Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYAQNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYAQNeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYAQNd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:33:57 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:40037 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYAQNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:33:56 -0500
Date: Thu, 17 Jan 2008 19:04:03 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org, balbir@linux.vnet.ibm.com
Subject: Re: 2.6.24-rc8-mm1
Message-ID: <20080117133403.GA17131@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails with following error

arch/x86/kernel/mpparse_32.c: In function `smp_read_mpc_oem':
arch/x86/kernel/mpparse_32.c:318: error: `oemtable' undeclared (first use in this function)
arch/x86/kernel/mpparse_32.c:318: error: (Each undeclared identifier is reported only once
arch/x86/kernel/mpparse_32.c:318: error: for each function it appears in.)
arch/x86/kernel/mpparse_32.c:332: error: `mpc_phys' undeclared (first use in this function)


This patch is build tested only.


Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
--- linux-2.6.24-rc8/arch/x86/kernel/mpparse_32.c	2008-01-17 18:02:45.000000000 +0530
+++ linux-2.6.24-rc8/arch/x86/kernel/~mpparse_32.c	2008-01-17 18:17:29.000000000 +0530
@@ -32,6 +32,7 @@
 #include <mach_apic.h>
 #include <mach_apicdef.h>
 #include <mach_mpparse.h>
+#include <asm/mpspec_def.h>
 
 /* Have we found an MP table */
 int smp_found_config;
@@ -329,7 +330,7 @@ static void __init smp_read_mpc_oem(unsi
 	oem_length = oemtable->oem_length;
 	/* Unmap header and map full base table */
 	early_iounmap(oemtable, sizeof(struct mp_config_oemtable));
-	oemtable = (struct mp_config_oemtable *)early_ioremap(mpc_phys,
+	oemtable = (struct mp_config_oemtable *)early_ioremap(oemtable_phys,
 					oem_length);
 	if (!oemtable) {
 		printk("MPTABLE: full oemtable map error!\n");

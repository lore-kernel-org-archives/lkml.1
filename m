Return-Path: <linux-kernel-owner+w=401wt.eu-S1764435AbXEWQII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764435AbXEWQII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbXEWQH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:07:57 -0400
Received: from holomorphy.com ([66.93.40.71]:52557 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389AbXEWQH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:07:56 -0400
Date: Wed, 23 May 2007 09:08:52 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070523160852.GV19966@holomorphy.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:42:33AM -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> - A new readahead patch series.  This needs serious review and performance
>   testing please.
> - Added Ingo's CFS CPU scheduler
> - Xen dom-U support is now in the x86 tree.

WARNING: arch/i386/mach-generic/built-in.o(.data+0xc4): Section mismatch: reference to .init.text: (between 'apic_bigsmp' and 'cpu.4905')
This appears to be resolvable by removing all the __init and __initdata
qualifiers from arch/i386/mach-generic/bigsmp.c

Signed-off-by: William Irwin <bill.irwin@oracle.com>

Index: mm-2.6.22-rc2/arch/i386/mach-generic/bigsmp.c
===================================================================
--- mm-2.6.22-rc2.orig/arch/i386/mach-generic/bigsmp.c	2007-05-23 08:53:25.122485613 -0700
+++ mm-2.6.22-rc2/arch/i386/mach-generic/bigsmp.c	2007-05-23 09:06:21.998757269 -0700
@@ -21,7 +21,7 @@
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
-static __init int hp_ht_bigsmp(struct dmi_system_id *d)
+static int hp_ht_bigsmp(struct dmi_system_id *d)
 {
 #ifdef CONFIG_X86_GENERICARCH
 	printk(KERN_NOTICE "%s detected: force use of apic=bigsmp\n", d->ident);
@@ -31,7 +31,7 @@
 }
 
 
-static struct dmi_system_id __initdata bigsmp_dmi_table[] = {
+static struct dmi_system_id bigsmp_dmi_table[] = {
 	{ hp_ht_bigsmp, "HP ProLiant DL760 G2", {
 		DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
 		DMI_MATCH(DMI_BIOS_VERSION, "P44-"),
@@ -45,7 +45,7 @@
 };
 
 
-static int __init probe_bigsmp(void)
+static int probe_bigsmp(void)
 { 
 	if (def_to_bigsmp)
         	dmi_bigsmp = 1;

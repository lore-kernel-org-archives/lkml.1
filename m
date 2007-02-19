Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXBSU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXBSU61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932655AbXBSU61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:58:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658AbXBSU60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:58:26 -0500
Date: Mon, 19 Feb 2007 15:58:16 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070219205816.13973.19711.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Add __init to probe_bigsmp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add __init to probe_bigsmp.  All callers are __init and data being examined
is __initdata.

Resolves MODPOST warning similar to:

WARNING: vmlinux - Section mismatch: reference to .init.data: from .text between 'probe_bigsmp' (at offset 0xc0401e56) and 'init_apic_ldr'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux-2.6.18.i386.orig/arch/i386/mach-generic/bigsmp.c	2007-02-05 13:29:12.000000000 -0500
+++ linux-2.6.18.i386/arch/i386/mach-generic/bigsmp.c	2007-02-13 13:15:06.000000000 -0500
@@ -44,7 +44,7 @@ static struct dmi_system_id __initdata b
 };
 
 
-static int probe_bigsmp(void)
+static int __init probe_bigsmp(void)
 { 
 	if (def_to_bigsmp)
         	dmi_bigsmp = 1;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbXKLFIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbXKLFIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 00:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXKLFHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 00:07:54 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:32238 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbXKLFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 00:07:53 -0500
Date: Sun, 11 Nov 2007 21:06:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: James.Bottomley@HansenPartnership.com, tglx@linutronix.de
Subject: [PATCH 3/3] voyager: fix smp init sections
Message-Id: <20071111210645.102b8f8d.randy.dunlap@oracle.com>
In-Reply-To: <20071111210335.35cc7b64.randy.dunlap@oracle.com>
References: <20071111210204.cbcf413e.randy.dunlap@oracle.com>
	<20071111210335.35cc7b64.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix Voyager section mismatch due to using __devinit instead of __cpuinit.

WARNING: vmlinux.o(.text+0xd943): Section mismatch: reference to .init.text:init_gdt (between 'voyager_smp_prepare_boot_cpu' and 'smp_vic_cmn_interrupt')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc2-git2.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6.24-rc2-git2/arch/x86/mach-voyager/voyager_smp.c
@@ -1900,7 +1900,7 @@ voyager_smp_prepare_cpus(unsigned int ma
 	smp_boot_cpus();
 }
 
-static void __devinit voyager_smp_prepare_boot_cpu(void)
+static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 {
 	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
@@ -1911,7 +1911,7 @@ static void __devinit voyager_smp_prepar
 	cpu_set(smp_processor_id(), cpu_present_map);
 }
 
-static int __devinit
+static int __cpuinit
 voyager_cpu_up(unsigned int cpu)
 {
 	/* This only works at boot for x86.  See "rewrite" above. */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbXKTOey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbXKTOey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXKTOeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:34:44 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:56845 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757599AbXKTOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:34:43 -0500
Date: Tue, 20 Nov 2007 20:04:36 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
Message-ID: <20071120143436.GB4438@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <4742C54B.1080709@linux.vnet.ibm.com> <alpine.LFD.0.9999.0711201405480.25057@localhost.localdomain> <alpine.LFD.0.9999.0711201520300.25057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.9999.0711201520300.25057@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 03:21:38PM +0100, Thomas Gleixner wrote:
> On Tue, 20 Nov 2007, Thomas Gleixner wrote:
> > > arch/x86/kernel/setup_64.c:991: error: redefinition of ‘identify_cpu’
> > > arch/x86/kernel/setup_64.c:958: error: previous definition of ‘identify_cpu’ was here
> > > make[1]: *** [arch/x86/kernel/setup_64.o] Error 1
> > > make: *** [arch/x86/kernel] Error 2
> > > 
> > > The patch causing this error is git-x86.patch
> > 
> > Jeremy pointed me to this already. I'm looking into this.
> 
> Fix below.
> 
>     tglx
>
Hi Thomas,

Thanks for the fix, the patch solves the build failure.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 arch/x86/kernel/setup_64.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/setup_64.c	2007-11-20 15:18:20.000000000 +0100
+++ linux-2.6-x86/arch/x86/kernel/setup_64.c	2007-11-20 15:18:57.000000000 +0100
@@ -634,8 +634,7 @@ static __cpuinit int amd_apic_timer_brok
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
-	unsigned bits;
-	unsigned ecx;
+	unsigned bits, ecx;
 
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level < 0x80000008)
@@ -942,13 +941,6 @@ static void __cpuinit early_identify_cpu
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
 #endif
-}
-
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
-{
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;


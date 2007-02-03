Return-Path: <linux-kernel-owner+w=401wt.eu-S1946258AbXBCCwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946258AbXBCCwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946291AbXBCCvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:51:40 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52869 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946239AbXBCChT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:37:19 -0500
Message-Id: <20070203024151.599542000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:31 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>
Subject: [patch 27/59] x86: Work around gcc 4.2 over aggressive optimizer
Content-Disposition: inline; filename=x86-work-around-gcc-4.2-over-aggressive-optimizer.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Andi Kleen <ak@suse.de>

The new PDA code uses a dummy _proxy_pda variable to describe
memory references to the PDA. It is never referenced
in inline assembly, but exists as input/output arguments.
gcc 4.2 in some cases can CSE references to this which causes
unresolved symbols.  Define it to zero to avoid this.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/i386/kernel/vmlinux.lds.S   |    1 +
 arch/x86_64/kernel/vmlinux.lds.S |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.19.2.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux-2.6.19.2/arch/i386/kernel/vmlinux.lds.S
@@ -13,6 +13,7 @@ OUTPUT_FORMAT("elf32-i386", "elf32-i386"
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
 jiffies = jiffies_64;
+_proxy_pda = 0;
 
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
--- linux-2.6.19.2.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux-2.6.19.2/arch/x86_64/kernel/vmlinux.lds.S
@@ -13,6 +13,7 @@ OUTPUT_FORMAT("elf64-x86-64", "elf64-x86
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
+_proxy_pda = 0;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */

--

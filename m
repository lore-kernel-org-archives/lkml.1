Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbXBIXs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbXBIXs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXBIXs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:48:56 -0500
Received: from ozlabs.org ([203.10.76.45]:53729 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbXBIXsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:48:55 -0500
Subject: [PATCH 11/10] lguest: use disable_acpi()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Len Brown <lenb@kernel.org>
Cc: James Morris <jmorris@namei.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <200702091249.58204.lenb@kernel.org>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <200702091206.31797.lenb@kernel.org>
	 <Pine.LNX.4.64.0702091212360.9007@d.namei>
	 <200702091249.58204.lenb@kernel.org>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 10:48:08 +1100
Message-Id: <1171064888.15356.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 12:49 -0500, Len Brown wrote:
> On Friday 09 February 2007 12:14, James Morris wrote:
> > This is being disabled in the guest kernel only.  The host and guest 
> > kernels are expected to be the same build.
> 
> Okay, but better to use disable_acpi()
> indeed, since this would be the first code not already inside CONFIG_ACPI
> to invoke disable_acpi(), we could define the inline as empty and you could
> then scratch the #ifdef too.

Thanks Len!

This applies on top of that series.

== 
Len Brown <lenb@kernel.org> said:
> Okay, but better to use disable_acpi()
> indeed, since this would be the first code not already inside CONFIG_ACPI
> to invoke disable_acpi(), we could define the inline as empty and you could
> then scratch the #ifdef too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 85363b87e20b arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c	Sat Feb 10 01:52:37 2007 +1100
+++ b/arch/i386/lguest/lguest.c	Sat Feb 10 10:28:36 2007 +1100
@@ -555,10 +555,7 @@ static __attribute_used__ __init void lg
 	mce_disabled = 1;
 #endif
 
-#ifdef CONFIG_ACPI
-	acpi_disabled = 1;
-	acpi_ht = 0;
-#endif
+	disable_acpi();
 	if (boot->initrd_size) {
 		/* We stash this at top of memory. */
 		INITRD_START = boot->max_pfn*PAGE_SIZE - boot->initrd_size;
diff -r 85363b87e20b include/asm-i386/acpi.h
--- a/include/asm-i386/acpi.h	Sat Feb 10 01:52:37 2007 +1100
+++ b/include/asm-i386/acpi.h	Sat Feb 10 10:43:43 2007 +1100
@@ -127,6 +127,7 @@ extern int acpi_irq_balance_set(char *st
 #define acpi_ioapic 0
 static inline void acpi_noirq_set(void) { }
 static inline void acpi_disable_pci(void) { }
+static inline void disable_acpi(void) { }
 
 #endif	/* !CONFIG_ACPI */
 




Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbYE2Scv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbYE2Scv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYE2Scm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:32:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:39783 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYE2Scl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Z00hD/L6io1w7BshTv0gK9p+aJOYi04XYs57OCW/3n5LIW45FBKFQ5deiULf06KTLt/JjlJ//ymm7xZe4itmvQ4mjC0JivyyY4WPEorcDcc5HGsX+bnsUweJwsY5hEzNzMMsh/mWMWigfpEqNJxqyj2OALsDYk+mZOzCnVQ1r1s=
Date: Thu, 29 May 2008 22:32:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: IO-APIC - use NMI_NONE instead of numeric constant
Message-ID: <20080529183230.GC6937@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Not sure but maybe it is better to use NMI_DISABLED,
will take a look. But for now this patch is not change
anything in logic so it will not hurt/broke the kernel.
For most cases nmi_watchdog assignment is by one of NMI_*
macro so I think there it make sense too.

Index: linux-2.6.git/arch/x86/kernel/io_apic_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic_32.c	2008-05-24 11:28:40.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic_32.c	2008-05-29 22:22:25.000000000 +0400
@@ -2217,7 +2217,7 @@ static inline void __init check_timer(vo
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
-		nmi_watchdog = 0;
+		nmi_watchdog = NMI_NONE;
 	}
 
 	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
Index: linux-2.6.git/arch/x86/kernel/io_apic_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic_64.c	2008-05-24 11:28:40.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic_64.c	2008-05-29 22:23:04.000000000 +0400
@@ -1735,7 +1735,7 @@ static inline void __init check_timer(vo
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
-		nmi_watchdog = 0;
+		nmi_watchdog = NMI_NONE;
 	}
 
 	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");

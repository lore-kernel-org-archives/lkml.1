Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYF0PoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYF0PoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYF0PoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:44:11 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:25839 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYF0PoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wTOi4LwpTzk+T46K3/LDrpaj13gIFtICTAFna7dKQAeGmAbcqR8Ri9zuwz2sp8Chop
         SFmvwdt9eodG74L1AWOHeStcXfeCh6qfZ3HxopTjGkk4fgViVKQg13A4hE6FHL+B5KSc
         +jDizBHU4idxVUUgSsM0HMIhe0lQRkZHBFrrs=
Date: Fri, 27 Jun 2008 19:43:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-ID: <20080627154340.GC18957@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nmi_watchdog is set to NMI_NONE by default (ie disabled) on _any_
mode so lets fix documentation too.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/Documentation/nmi_watchdog.txt
====================================================================
--- linux-2.6.git.orig/Documentation/nmi_watchdog.txt	2008-04-15 23:01:26.000000000 +0400
+++ linux-2.6.git/Documentation/nmi_watchdog.txt	2008-06-27 19:39:21.000000000 +0400
@@ -10,7 +10,7 @@ us to generate 'watchdog NMI interrupts'
 which get executed even if the system is otherwise locked up hard).
 This can be used to debug hard kernel lockups.  By executing periodic
 NMI interrupts, the kernel can monitor whether any CPU has locked up,
-and print out debugging messages if so.  
+and print out debugging messages if so.
 
 In order to use the NMI watchdog, you need to have APIC support in your
 kernel. For SMP kernels, APIC support gets compiled in automatically. For
@@ -22,8 +22,7 @@ CONFIG_X86_UP_IOAPIC is for uniprocessor
 kernel debugging options, such as Kernel Stack Meter or Kernel Tracer,
 may implicitly disable the NMI watchdog.]
 
-For x86-64, the needed APIC is always compiled in, and the NMI watchdog is
-always enabled with I/O-APIC mode (nmi_watchdog=1).
+For x86-64, the needed APIC is always compiled in.
 
 Using local APIC (nmi_watchdog=2) needs the first performance register, so
 you can't use it for other purposes (such as high precision performance
@@ -63,16 +62,15 @@ when the system is idle), but if your sy
 "hlt", then you are out of luck -- the event will not happen at all and the
 watchdog won't trigger. This is a shortcoming of the local APIC watchdog
 -- unfortunately there is no "clock ticks" event that would work all the
-time. The I/O APIC watchdog is driven externally and has no such shortcoming.  
+time. The I/O APIC watchdog is driven externally and has no such shortcoming.
 But its NMI frequency is much higher, resulting in a more significant hit
 to the overall system performance.
 
-NOTE: starting with 2.4.2-ac18 the NMI-oopser is disabled by default,
-you have to enable it with a boot time parameter.  Prior to 2.4.2-ac18
-the NMI-oopser is enabled unconditionally on x86 SMP boxes.
+On x86 nmi_watchdog is disabled by default so you have to enable it with
+a boot time parameter.
 
-On x86-64 the NMI oopser is on by default. On 64bit Intel CPUs
-it uses IO-APIC by default and on AMD it uses local APIC.
+NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
+on x86 SMP boxes.
 
 [ feel free to send bug reports, suggestions and patches to
   Ingo Molnar <mingo@redhat.com> or the Linux SMP mailing

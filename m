Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYF0QCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYF0QCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYF0QC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:02:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:33549 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYF0QCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RN65pge/jgB47M8xvvU9dwjvje2hIJ6AtxBDxJ0USz0Uwu3Z2yoCwsJN0u4KgWAoc4
         bdyeWy8xWCw2p3ENFq/zR8eAKb7YZoN0F9RCVF8Cm3YyTtxfpjvGqy+rGCYS009T843/
         Wvvg/Q20nufZ0FpRfkkfUv0iXU/fOer6QSsxc=
Date: Fri, 27 Jun 2008 20:01:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-ID: <20080627160156.GD18957@cvg>
References: <20080627154340.GC18957@cvg> <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Fri, Jun 27, 2008 at 04:54:19PM +0100]
| On Fri, 27 Jun 2008, Cyrill Gorcunov wrote:
| 
| > +NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
| > +on x86 SMP boxes.
| 
|  While you are at it: s/is/was/.
| 
|   Maciej
| 
Thanks, Maciej, updated.

		- Cyrill -
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH -tip/master] x86: nmi_watchdog - documentation fix

nmi_watchdog is set to NMI_NONE by default (ie disabled) on _any_
mode so lets fix documentation too.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Maciej W. Rozycki <macro@linux-mips.org>
---

Index: linux-2.6.git/Documentation/nmi_watchdog.txt
====================================================================
--- linux-2.6.git.orig/Documentation/nmi_watchdog.txt	2008-06-27 19:50:06.000000000 +0400
+++ linux-2.6.git/Documentation/nmi_watchdog.txt	2008-06-27 19:58:53.000000000 +0400
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
+NOTE: Prior to 2.4.2-ac18 the NMI-oopser was enabled unconditionally
+on x86 SMP boxes.
 
 [ feel free to send bug reports, suggestions and patches to
   Ingo Molnar <mingo@redhat.com> or the Linux SMP mailing

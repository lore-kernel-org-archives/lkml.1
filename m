Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYKAPHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYKAPHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 11:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYKAPHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 11:07:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:42590 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYKAPG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 11:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v22Ea5quoepHn9tqV2MEvOy2H6xAoDSIoEFgQt1vJTQTppPAbj0ztV0xss2hl291VL
         Y1Wrm45muf56nBeD6pEUI3l9vij2/dQ8yWa2FXEEthBrJ6c6SjQWNj7gCDntjgRyjyVc
         TqtP1tcelrY5eyGhxBL9B5Or1EIs6Wur5M0WM=
Date: Sat, 1 Nov 2008 18:06:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH] x86: nmi - nmi_watchdog boot param docs cleanup
Message-ID: <20081101150651.GA8106@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) nmi_watchdog boot parameter is common to 32/64 bit modes. So
move it from Documentation/x86/x86_64/boot-options.txt to
Documentation/kernel-parameters.txt and integrate with.

2) Also fix [panic] keyword placement -- it ought to be at first
position otherwise it will not be recognized.

3) Document lapoc and ioapic keywords.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

It's a bit fun but 'panic' was placed on a second
position which is just a plain wrong :-)

On top of -tip dda51106620c328b50007c259b9ef8cea2b7c3d2

Index: linux-2.6.git/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.git.orig/Documentation/kernel-parameters.txt	2008-10-27 21:35:08.000000000 +0300
+++ linux-2.6.git/Documentation/kernel-parameters.txt	2008-11-01 17:53:08.000000000 +0300
@@ -1403,7 +1403,20 @@ and is between 256 and 4096 characters. 
 			when a NMI is triggered.
 			Format: [state][,regs][,debounce][,die]
 
-	nmi_watchdog=	[KNL,BUGS=X86-32] Debugging features for SMP kernels
+	nmi_watchdog=	[KNL,BUGS=X86-32,X86-64] Debugging features for SMP kernels
+			Format: [panic,][num]
+			Valid num: 0,1,2
+			0 - turn nmi_watchdog off
+			1 - use the IO-APIC timer for the NMI watchdog
+			2 - use the local APIC for the NMI watchdog using
+			a performance counter. Note: This will use one performance
+			counter and the local APIC's performance vector.
+			When panic is specified panic when an NMI watchdog timeout occurs.
+			This is useful when you use a panic=... timeout and need the box
+			quickly up again.
+			Instead of 1 and 2 it is possible to use the following
+			symbolic names: lapic and ioapic
+			Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
 
 	no387		[BUGS=X86-32] Tells the kernel to use the 387 maths
 			emulation library even if a 387 maths coprocessor
Index: linux-2.6.git/Documentation/x86/x86_64/boot-options.txt
===================================================================
--- linux-2.6.git.orig/Documentation/x86/x86_64/boot-options.txt	2008-10-27 21:35:08.000000000 +0300
+++ linux-2.6.git/Documentation/x86/x86_64/boot-options.txt	2008-11-01 17:52:22.000000000 +0300
@@ -79,17 +79,6 @@ Timing
   Report when timer interrupts are lost because some code turned off
   interrupts for too long.
 
-  nmi_watchdog=NUMBER[,panic]
-  NUMBER can be:
-  0 don't use an NMI watchdog
-  1 use the IO-APIC timer for the NMI watchdog
-  2 use the local APIC for the NMI watchdog using a performance counter. Note
-  This will use one performance counter and the local APIC's performance
-  vector.
-  When panic is specified panic when an NMI watchdog timeout occurs.
-  This is useful when you use a panic=... timeout and need the box
-  quickly up again.
-
   nohpet
   Don't use the HPET timer.
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbYBRBDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbYBRBDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYBRBDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:03:17 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:57121 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbYBRBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:03:16 -0500
Message-ID: <47B8D99A.3020202@larces.uece.br>
Date: Sun, 17 Feb 2008 22:04:26 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8):
 undefined reference to `LGUEST_PAGES_regs_trapnum'
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <alpine.LFD.1.00.0802171451060.7583@apollo.tec.linutronix.de> <47B83F90.7000203@larces.uece.br> <alpine.DEB.1.00.0802172109590.6469@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0802172109590.6469@sheep.housecafe.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> On Sun, 17 Feb 2008, Sergio Luis wrote:
>> It doesn't fix the problem totally. If we select
>> Virtualization->Linux hypervisor example code (CONFIG_LGUEST)
>> as a module, we will get the same build errors,
> 
> Confirmed, the build errors persist with CONFIG_LGUEST=m and Rusty's
> patch applied.
> 
> thanks,
> Christian.

This will make sure CONFIG_LGUEST is set when building the linux hypervisor example code as both module and built-in,
so that the LGUEST_* offsets will be generated for both cases in asm-offset.h.
I am sure you guys will have a better way to fix this, but anyway... 
-sergio

--- linux-2.6.25-rc2.orig/drivers/lguest/Kconfig	2008-02-16 23:21:29.000000000 -0300
+++ linux-2.6.25-rc2/drivers/lguest/Kconfig	2008-02-17 21:44:57.000000000 -0300
@@ -1,7 +1,17 @@
 config LGUEST
-	tristate "Linux hypervisor example code"
+	bool "Linux hypervisor"
 	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX && !(X86_VISWS || X86_VOYAGER)
+	default y 
+	---help---
+	  This allows you to select the linux hypervisor example code.
+
+if LGUEST
+
+config LGUEST_HYPERVISOR
+	tristate "Linux hypervisor example code"
+	depends on LGUEST
 	select HVC_DRIVER
+	default m
 	---help---
 	  This is a very simple module which allows you to run
 	  multiple instances of the same Linux kernel, using the
@@ -10,3 +20,5 @@
 	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
 
 	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
+
+endif # LGUEST


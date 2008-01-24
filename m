Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYAXXHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYAXXHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYAXXGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:06:55 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53600 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753475AbYAXXGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:06:54 -0500
Date: Fri, 25 Jan 2008 00:05:59 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 03/26] Move Kconfig.instrumentation to arch/Kconfig and
 init/Kconfig
Message-ID: <20080125000559.52e17977@sheeana.local>
In-Reply-To: <20080124203333.499728934@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
	<20080124203333.499728934@polymtl.ca>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i386-apple-darwin8.10.1)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 15:27:09 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> Remove the "Instrumentation Support" menu. Everything moves to "General setup".
> Delete the kernel/Kconfig.instrumentation file.

Hmm. In preparation for oprofile, I currently have the below in my avr32
tree (i.e. -mm). What's the best way to deal with that?

I intend to push this early once the merge window opens. Could you just
remove the instrumentation menu from avr32 as well in your patch? It
should still apply nicely to -mm.

Haavard

commit 5ad893c907a645def629bbdab3a1c114f619bf1c
Author: Haavard Skinnemoen <hskinnemoen@atmel.com>
Date:   Wed Oct 31 15:22:34 2007 +0100

    [AVR32] Include instrumentation menu
    
    Remove KPROBES option from Kconfig.debug and include
    kernel/Kconfig.instrumentation.
    
    Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index b77abce..bc08c7f 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -219,6 +219,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/avr32/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/avr32/Kconfig.debug b/arch/avr32/Kconfig.debug
index 64ace00..2283933 100644
--- a/arch/avr32/Kconfig.debug
+++ b/arch/avr32/Kconfig.debug
@@ -6,14 +6,4 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config KPROBES
-	bool "Kprobes"
-	depends on DEBUG_KERNEL
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-          execute a callback function.  register_kprobe() establishes
-          a probepoint and specifies the callback.  Kprobes is useful
-          for kernel debugging, non-intrusive instrumentation and testing.
-          If in doubt, say "N".
-
 endmenu

Return-Path: <linux-kernel-owner+w=401wt.eu-S967725AbXEHNtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967725AbXEHNtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967418AbXEHNti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:49:38 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4891 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967329AbXEHNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:49:37 -0400
Date: Tue, 8 May 2007 14:49:28 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Andi Kleen <andi@basil.nowhere.org>
Subject: Please revert 86c0baf123e474b6eb404798926ecf62b426bf3a
Message-ID: <20070508134928.GA13212@flint.arm.linux.org.uk>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	Prarit Bhargava <prarit@redhat.com>,
	Andi Kleen <andi@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The change:

+#ifdef CONFIG_HOTPLUG_CPU
+#define __INIT		.section	".text","ax"
+#define __INITDATA	.section	".data","aw"
+#else
 #define __INIT		.section	".init.text","ax"
-#define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
+#endif
+#define __FINIT		.previous

breaks ARM, since the ARM startup code moves from the start of the image
to somewhere in the middle of the kernel image.  (That's trivially fixable.)

Besides that, this change is also wrong because not all assembly marked
__INIT needs to be moved into the standard .text segment when hotplug CPU
is enabled.  Ditto for __INITDATA.

One is left wondering why the original patch proposers didn't:

1. Invent __CPUINIT and __CPUINITDATA, to be consistent with __init vs
   __cpuinit.

2. copy other architecture maintainers.

Shall I invent __CPUINIT to mark data to always be thrown away, or are
the x86 folk going to withdraw this patch and do it properly?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

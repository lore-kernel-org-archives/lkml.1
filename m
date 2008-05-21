Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbYEUJql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbYEUJql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYEUJqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:46:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55980 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbYEUJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:46:32 -0400
Date: Wed, 21 May 2008 11:47:24 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       macro@ds2.pg.gda.pl
Subject: i8259.c: remove #ifdefs around includes
Message-ID: <20080521094724.GC12763@elf.ucw.cz>
References: <20080520151528.GA1596@elf.ucw.cz> <20080520204750.GA31409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520204750.GA31409@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove #ifdefs around includes; including too much should be always
safe.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 06f12eb6da33da70dbdccbee5a687d5353782e1d
tree 62b9b1a785bbc5a9daa22512ec95601d54aa004d
parent 44b4ec2247971ba1a1906752208182146fc5974c
author Pavel <pavel@amd.ucw.cz> Wed, 21 May 2008 11:46:46 +0200
committer Pavel <pavel@amd.ucw.cz> Wed, 21 May 2008 11:46:46 +0200

 arch/x86/kernel/i8259.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 2decba6..8b7eb0c 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -1,14 +1,10 @@
-#ifdef CONFIG_X86_64
 #include <linux/linkage.h>
-#endif /* CONFIG_X86_64 */
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
-#ifdef CONFIG_X86_64
 #include <linux/timex.h>
-#endif /* CONFIG_X86_64 */
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/init.h>
@@ -16,24 +12,17 @@ #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
 
-#ifdef CONFIG_X86_64
 #include <asm/acpi.h>
-#endif /* CONFIG_X86_64 */
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/io.h>
-#ifndef CONFIG_X86_64
 #include <asm/timer.h>
-#else /* CONFIG_X86_64 */
 #include <asm/hw_irq.h>
-#endif /* CONFIG_X86_64 */
 #include <asm/pgtable.h>
 #include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
-#ifndef CONFIG_X86_64
 #include <asm/arch_hooks.h>
-#endif /* ! CONFIG_X86_64 */
 #include <asm/i8259.h>
 
 /*

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

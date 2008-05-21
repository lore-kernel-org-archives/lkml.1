Return-Path: <linux-kernel-owner+w=401wt.eu-S1764662AbYEUJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764662AbYEUJwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYEUJwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:52:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58107 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYEUJwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:52:00 -0400
Date: Wed, 21 May 2008 11:52:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       macro@ds2.pg.gda.pl
Subject: i8259.c: remove trivial ifdefs
Message-ID: <20080521095252.GD12763@elf.ucw.cz>
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

Remove #ifdefs where the only difference is formatting of comments.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 800e1add46a2686995af98432a7971150318676d
tree 5daa71306ceb60b0fb7e5707ec4d9701c06197de
parent 06f12eb6da33da70dbdccbee5a687d5353782e1d
author Pavel <pavel@amd.ucw.cz> Wed, 21 May 2008 11:52:11 +0200
committer Pavel <pavel@amd.ucw.cz> Wed, 21 May 2008 11:52:11 +0200

 arch/x86/kernel/i8259.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 8b7eb0c..433e49e 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -175,24 +175,14 @@ handle_real_irq:
 	if (irq & 8) {
 		inb(PIC_SLAVE_IMR);	/* DUMMY - (do we need this?) */
 		outb(cached_slave_mask, PIC_SLAVE_IMR);
-#ifndef CONFIG_X86_64
-		outb(0x60+(irq&7),PIC_SLAVE_CMD);/* 'Specific EOI' to slave */
-		outb(0x60+PIC_CASCADE_IR,PIC_MASTER_CMD); /* 'Specific EOI' to master-IRQ2 */
-#else /* CONFIG_X86_64 */
 		/* 'Specific EOI' to slave */
-		outb(0x60+(irq&7),PIC_SLAVE_CMD);
+		outb(0x60+(irq&7), PIC_SLAVE_CMD);
 		 /* 'Specific EOI' to master-IRQ2 */
-		outb(0x60+PIC_CASCADE_IR,PIC_MASTER_CMD);
-#endif /* CONFIG_X86_64 */
+		outb(0x60+PIC_CASCADE_IR, PIC_MASTER_CMD);
 	} else {
 		inb(PIC_MASTER_IMR);	/* DUMMY - (do we need this?) */
 		outb(cached_master_mask, PIC_MASTER_IMR);
-#ifndef CONFIG_X86_64
-		outb(0x60+irq,PIC_MASTER_CMD);	/* 'Specific EOI to master */
-#else /* CONFIG_X86_64 */
-		/* 'Specific EOI' to master */
-		outb(0x60+irq,PIC_MASTER_CMD);
-#endif /* CONFIG_X86_64 */
+		outb(0x60+irq, PIC_MASTER_CMD);	/* 'Specific EOI to master */
 	}
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 	return;
@@ -215,12 +205,8 @@ spurious_8259A_irq:
 		 * lets ACK and report it. [once per IRQ]
 		 */
 		if (!(spurious_irq_mask & irqmask)) {
-#ifndef CONFIG_X86_64
-			printk(KERN_DEBUG "spurious 8259A interrupt: IRQ%d.\n", irq);
-#else /* CONFIG_X86_64 */
 			printk(KERN_DEBUG
 			       "spurious 8259A interrupt: IRQ%d.\n", irq);
-#endif /* CONFIG_X86_64 */
 			spurious_irq_mask |= irqmask;
 		}
 		atomic_inc(&irq_err_count);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

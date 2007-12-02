Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbXLBQkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbXLBQkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXLBQkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:40:45 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:57664 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXLBQko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:40:44 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: disable hpet legacy replacement for kdump
References: <20071126193353.GA1676@elte.hu>
	<87sl2s4ran.fsf@duaron.myhome.or.jp>
Date: Mon, 03 Dec 2007 01:40:34 +0900
In-Reply-To: <87sl2s4ran.fsf@duaron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue, 27 Nov 2007 06:42:40 +0900")
Message-ID: <8763zhrqwt.fsf_-_@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> This seems to introduced after 2.6.23, so if possible, I'd like to fix
> before 2.6.24. What do you think the following?

The following patch fixes the kdump path. Please apply.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


    [PATCH] x86: disable hpet legacy replacement for kexec

Like the above patch, we should also add hpet_disable() for kdump.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 arch/x86/kernel/crash.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/x86/kernel/crash.c~kdump-need-to-disable-hpet arch/x86/kernel/crash.c
--- linux-2.6/arch/x86/kernel/crash.c~kdump-need-to-disable-hpet	2007-11-29 12:21:55.000000000 +0900
+++ linux-2.6-hirofumi/arch/x86/kernel/crash.c	2007-11-29 12:34:21.000000000 +0900
@@ -22,6 +22,7 @@
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/hpet.h>
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 
@@ -140,5 +141,8 @@ void machine_crash_shutdown(struct pt_re
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
 #endif
+#ifdef CONFIG_HPET_TIMER
+	hpet_disable();
+#endif
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
_

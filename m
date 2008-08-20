Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYHTA2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYHTA2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYHTA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:28:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbYHTA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:28:33 -0400
Date: Tue, 19 Aug 2008 17:27:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: randy.dunlap@oracle.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] merge io_apic_xx.c -- fix
Message-Id: <20080819172757.63b16451.akpm@linux-foundation.org>
In-Reply-To: <86802c440808191724j68f50b1fx7b2488963fcf96fd@mail.gmail.com>
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>
	<20080816133554.GB11063@elte.hu>
	<20080819152156.c79f31e4.randy.dunlap@oracle.com>
	<86802c440808191724j68f50b1fx7b2488963fcf96fd@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 17:24:08 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Tue, Aug 19, 2008 at 3:21 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Sat, 16 Aug 2008 15:35:54 +0200 Ingo Molnar wrote:
> >
> >>
> >> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >>
> >> >     merge io_apic_xx.c
> >> >
> >> > Thanks
> >>
> >> applied to tip/irq/sparseirq - thanks!
> >
> >
> > Are there patches in the io_apic series to fix these warnings in linux-next?? ::
> >
> >
> > linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> > linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64
> >
> >
> > and
> >
> > linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> > linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> >
> 
> No

yes

From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/io_apic_32.c: In function 'print_local_APIC':
arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'

No need for casting here - we know what type u64 has.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/io_apic_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/io_apic_32.c~arch-x86-kernel-io_apic_32c-fix-printk-warnings arch/x86/kernel/io_apic_32.c
--- a/arch/x86/kernel/io_apic_32.c~arch-x86-kernel-io_apic_32c-fix-printk-warnings
+++ a/arch/x86/kernel/io_apic_32.c
@@ -1536,8 +1536,8 @@ __apicdebuginit(void) print_local_APIC(v
 	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
+	printk(KERN_DEBUG "... APIC ICR: %08Lx\n", icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08Lx\n", icr >> 32);
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
_


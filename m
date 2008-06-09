Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYFITCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYFITCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYFITC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:02:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYFITCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:02:25 -0400
Date: Mon, 9 Jun 2008 21:02:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: coding style fixes to arch/x86/kernel/io_apic_32.c
Message-ID: <20080609190204.GA13674@elte.hu>
References: <20080608130718.5d36e25b@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080608130718.5d36e25b@paolo-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> Before:
> total: 91 errors, 73 warnings, 2850 lines checked
> 
> After:
> total: 1 errors, 47 warnings, 2848 lines checked

applied, thanks. A small detail:

> +++ b/arch/x86/kernel/io_apic_32.c
> @@ -37,12 +37,12 @@
>  #include <linux/kthread.h>
>  #include <linux/jiffies.h>	/* time_after() */
>  
> -#include <asm/io.h>
> -#include <asm/smp.h>
> +#include <linux/io.h>
> +#include <linux/smp.h>

i suspect checkpatch suggested that asm/smp.h -> linux/smp.h change, but 
there was a subtle detail here - asm/smp.h has dual role on x86, it also 
carries a fair number of low level details about APIC/SMP details - 
which matters on UP IOAPIC.

so the fix below was needed as well.

	Ingo

------------->
Subject: build fix to "x86: coding style fixes to arch/x86/kernel/io_apic_32.c"
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Jun 09 20:58:55 CEST 2008

io_apic_32.c relied on asm/smp.h include, to pick up lowlevel
arch details:

arch/x86/kernel/io_apic_32.c:75: error: array type has incomplete element type
arch/x86/kernel/io_apic_32.c:79: error: array type has incomplete element type
arch/x86/kernel/io_apic_32.c:152: error: field ‘entry’ has incomplete type
arch/x86/kernel/io_apic_32.c:156: error: return type is an incomplete type
arch/x86/kernel/io_apic_32.c: In function ‘ioapic_read_entry’:
arch/x86/kernel/io_apic_32.c:163: warning: ‘return’ with a value, in function returning void
arch/x86/kernel/io_apic_32.c: At top level:

so add it back.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/io_apic_32.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux.orig/arch/x86/kernel/io_apic_32.c
+++ linux/arch/x86/kernel/io_apic_32.c
@@ -39,6 +39,8 @@
 
 #include <linux/io.h>
 #include <linux/smp.h>
+
+#include <asm/smp.h>
 #include <asm/desc.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbXL3WKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbXL3WKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXL3WKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:10:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38622 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXL3WKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:10:22 -0500
Date: Sun, 30 Dec 2007 23:02:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230220206.GD31386@elte.hu>
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it> <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it> <E1J92JB-00013N-P3@be1.7eggert.dyndns.org> <20071230181004.GA21968@elte.hu> <477805F1.4070201@zytor.com> <20071230210007.GA3136@elte.hu> <20071230213309.70d9d1e0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230213309.70d9d1e0@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > ok. Like the patch below?
> 
> Not quite - you still need the loop in case you NMI and then run off 
> into oblivion

yes indeed. Updated patch below.

	Ingo

-------------->
Subject: x86: hlt on early crash
From: Ingo Molnar <mingo@elte.hu>

H. Peter Anvin <hpa@zytor.com> wrote:

> It probably should actually HLT, to avoid sucking power, and stressing
> the thermal system.  We're dead at this point, and the early 486's
> which had problems with HLT will lock up - we don't care.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/compressed/misc_32.c |    3 ++-
 arch/x86/boot/compressed/misc_64.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/boot/compressed/misc_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/boot/compressed/misc_32.c
+++ linux-x86.q/arch/x86/boot/compressed/misc_32.c
@@ -339,7 +339,8 @@ static void error(char *x)
 	putstr(x);
 	putstr("\n\n -- System halted");
 
-	while(1);	/* Halt */
+	while (1)
+		asm("hlt");
 }
 
 asmlinkage void decompress_kernel(void *rmode, unsigned long end,
Index: linux-x86.q/arch/x86/boot/compressed/misc_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/boot/compressed/misc_64.c
+++ linux-x86.q/arch/x86/boot/compressed/misc_64.c
@@ -338,7 +338,8 @@ static void error(char *x)
 	putstr(x);
 	putstr("\n\n -- System halted");
 
-	while(1);	/* Halt */
+	while (1)
+		asm("hlt");
 }
 
 asmlinkage void decompress_kernel(void *rmode, unsigned long heap,


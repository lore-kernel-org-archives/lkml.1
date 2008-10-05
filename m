Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYJEKl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYJEKl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYJEKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:41:50 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:5046 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYJEKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:41:49 -0400
Date: Sun, 5 Oct 2008 12:39:36 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] dumpstack: x86: various small unification steps
Message-ID: <20081005103936.GA15118@mailshack.com>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm> <20081005093523.GE16819@elte.hu> <20081005094615.GA27621@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005094615.GA27621@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 05 Oct 2008 12:41:31 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After "dumpstack: x86: various small unification steps", the
assembler gives the following compile error. The error is in
dumpstack_64.c.

{standard input}: Assembler messages:
{standard input}:720: Error: Incorrect register `%rbx' used with `l' suffix
{standard input}:1340: Error: Incorrect register `%r12' used with `l' suffix

Indeed the suffix in get_bp() was wrong.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

On Sun, Oct 05, 2008 at 11:46:15AM +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > great - i've created tip/x86/dumpstack for this and applied your 
> > patches there. (that branch embedds tip/x86/core which already embedds 
> > tip/x86/traps)
> 
> -tip testing found a 64-bit build failure:
> 
> {standard input}: Assembler messages:
> {standard input}:720: Error: Incorrect register `%rbx' used with `l' suffix
> {standard input}:1340: Error: Incorrect register `%r12' used with `l' suffix
> 
> reproducer config attached.
> 
> 	Ingo

Hi Ingo,

"dumpstack: x86: various small unification steps" contained
another copy/paste/forgot-to-edit bug. I should have gone
to bed instead of rushing the patch set out.

Greetings,
    Alexander

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 13379a9..086cc81 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -17,7 +17,7 @@
 #include <asm/stacktrace.h>
 
 #define STACKSLOTS_PER_LINE 4
-#define get_bp(bp) asm("movl %%rbp, %0" : "=r" (bp) :)
+#define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
 
 int panic_on_unrecovered_nmi;
 int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;

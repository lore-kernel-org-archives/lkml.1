Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYKTPam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYKTPam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYKTPae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:30:34 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:2740 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYKTPad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:30:33 -0500
Date: Thu, 20 Nov 2008 16:26:01 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: clean up after: move entry_64.S register saving out of the macros
Message-ID: <20081120152601.GA3953@mailshack.com>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120150412.GC13550@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Thu, 20 Nov 2008 16:28:44 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.34; VDF: 7.1.0.114; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 04:04:12PM +0100, Ingo Molnar wrote:
> 
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
> > This add-on patch to x86: move entry_64.S register saving out of the 
> > macros visually cleans up the appearance of the code by introducing 
> > some basic helper macro's. It also adds some cfi annotations which 
> > were missing.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > ---
> >  arch/x86/kernel/entry_64.S |  220 ++++++++++++++++++++++----------------------
> >  1 files changed, 112 insertions(+), 108 deletions(-)
> > 
> > Hello Ingo,
> > 
> > This patch improves the CFI-situation in entry_64.S, but restricted 
> > mostly to the areas touched by "x86: move entry_64.S register saving 
> > out of the macros". I'm sure there will be some small errors 
> > somewhere, but it compiles and runs fine.
> 
> very nice cleanup! This is exactly what should be done. Applied to 
> tip/x86/irq.
> 
> Note, i did a small rename:
> 
>     cfi_pushq  =>  pushq_cfi
>     cfi_popq   =>  popq_cfi
>     cfi_store  =>  movq_cfi
> 
> as the goal is to have the actual source code read mostly as regular 
> assembly code. The fact that the macro is equivalent to a 
> default-annotated pushq/popq/movq instruction is much more important 
> than the fact that it also does CFI annotations.
> 
> Also, while cfi_store is correct as well, the usual x86 assembly term 
> (and instruction used here) is movq.

Now I have a little problem with my next patch... I wanted to
introduce cfi_load. Guess what assembly instruction that maps
to ;).

Greetings,
	Alexander

> Find below how the commit ended up looking like.
> 
> Thanks,
> 
> 	Ingo
> 
> ----------------->
-- 
Alexander van Heukelum

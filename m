Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYGUXZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYGUXZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYGUXZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:25:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42656 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753257AbYGUXZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:25:39 -0400
Message-ID: <48851AF0.5070309@sgi.com>
Date: Mon, 21 Jul 2008 16:25:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: BUILD_IRQ say .text to avoid .data.percpu
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> When I edit the x86_64 Makefile to -fno-unit-at-a-time, bootup panics
> on 0xCCs in IRQ0x3e_interrupt(): IRQ0x20_interrupt etc. have got linked
> into .data.percpu.  Perhaps there are other ways of triggering that:
> specify ".text" in the BUILD_IRQ() macro for safety.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> I've been using -fno-unit-at-a-time (to lessen inlining, for easier
> debugging) for a long time, but never saw this until Mike's percpu mods
> came in: I mention this so you're on the lookout, just in case other
> things are more likely to go into the wrong section now.  (I did give
> Mike a private headsup on this a couple of weeks ago, in case it helped
> with problems he was having with percpu, but in fact it didn't help.)
> 
>  arch/x86/kernel/irqinit_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.26-git/arch/x86/kernel/irqinit_64.c	2008-07-18 11:33:31.000000000 +0100
> +++ linux/arch/x86/kernel/irqinit_64.c	2008-07-18 16:07:00.000000000 +0100
> @@ -43,7 +43,7 @@
>  
>  #define BUILD_IRQ(nr)				\
>  	asmlinkage void IRQ_NAME(nr);		\
> -	asm("\n.p2align\n"			\
> +	asm("\n.text\n.p2align\n"		\
>  	    "IRQ" #nr "_interrupt:\n\t"		\
>  	    "push $~(" #nr ") ; "		\
>  	    "jmp common_interrupt");


Thanks Hugh.  Btw, which GCC are you using?

-Mike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYGaQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYGaQcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYGaQcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:32:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYGaQcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:32:08 -0400
Date: Thu, 31 Jul 2008 18:31:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 5/6] x86: coding style fixes to
	arch/x86/kernel/traps_64.c
Message-ID: <20080731163150.GD26393@elte.hu>
References: <gustavo@las.ic.unicamp.br> <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br> <1217310536-7181-2-git-send-email-gustavo@las.ic.unicamp.br> <1217310536-7181-3-git-send-email-gustavo@las.ic.unicamp.br> <1217310536-7181-4-git-send-email-gustavo@las.ic.unicamp.br> <1217310536-7181-5-git-send-email-gustavo@las.ic.unicamp.br> <1217310536-7181-6-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217310536-7181-6-git-send-email-gustavo@las.ic.unicamp.br>
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


* Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:

>  void printk_address(unsigned long address, int reliable)
>  {
> -	printk(" [<%016lx>] %s%pS\n", address, reliable ? "": "? ", (void *) address);
> +	printk(" [<%016lx>] %s%pS\n", address, reliable ?
> +			"" : "? ", (void *) address);

careful with line 80 warnings. This one is better broken up the 
following way:

	printk(" [<%016lx>] %s%pS\n",
	       address, reliable ? "": "? ", (void *) address);

so that logically coherent pieces of code stay together. (the arguments 
to the printk() function call in this case)

>  #if DEBUG_STKSZ > EXCEPTION_STKSZ
> -		[N_EXCEPTION_STACKS ... N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
> +		[N_EXCEPTION_STACKS ... N_EXCEPTION_STACKS + DEBUG_STKSZ /
> +			EXCEPTION_STKSZ - 2] = "#DB[?]"

this too is done better in another way:

	[N_EXCEPTION_STACKS ... 
	 N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"

> -	// debugging aid: "show_stack(NULL, NULL);" prints the
> -	// back trace for this cpu.
> +	/* debugging aid: "show_stack(NULL, NULL);" prints the
> +	  back trace for this cpu. */

please use the standard multi-line comment format:

	/*
	 * Multi-line ...........
	 * .............. comment.
	 */

i've applied your patches already to x86/cleanups, so please send a 
delta patch against that branch to fix these few items up. You can pick 
it up via:

    http://people.redhat.com/mingo/tip.git/README

and do:

    git-checkout tip/x86/cleanups

to check out that exact tree. (You might also want to work against 
tip/master, which has the same changes.)

	Ingo

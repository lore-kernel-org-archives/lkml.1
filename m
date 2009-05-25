Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZEYKj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZEYKj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZEYKjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:39:20 -0400
Received: from www.tglx.de ([62.245.132.106]:37715 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZEYKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:39:20 -0400
Date: Mon, 25 May 2009 12:33:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bart Oldeman <bartoldeman@users.sourceforge.net>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, stable@kernel.org
Subject: Re: [PATCH] x86, vm86: fix preemption bug for int3 breakpoint
 handlers.
In-Reply-To: <alpine.DEB.2.00.0905241834110.17184@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905251225190.3582@localhost.localdomain>
References: <alpine.DEB.2.00.0905241834110.17184@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart,

On Sun, 24 May 2009, Bart Oldeman wrote:
> diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
> index b8035a0..17c7734 100644
> --- a/arch/x86/kernel/vm86_32.c
> +++ b/arch/x86/kernel/vm86_32.c
> @@ -551,8 +551,12 @@ cannot_handle:
>  int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int
> trapno)
>  {
>  	if (VMPI.is_vm86pus) {
> -		if ((trapno == 3) || (trapno == 1))
> +		if ((trapno == 3) || (trapno == 1)) {
> +			/* re-enable preemption: return_to_32bit()
> +			   jumps straight to entry_32.S */
> +			dec_preempt_count();

  This will break other callers of handle_vm86_trap().

Thanks,

	tglx



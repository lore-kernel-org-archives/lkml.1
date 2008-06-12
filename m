Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYFLHFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYFLHFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYFLHFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:05:11 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:4783 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753345AbYFLHFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:05:10 -0400
Subject: Re: [2.6.26-rc5-git2] WARNING: at kernel/lockdep.c:2658
	check_flags+0x4c/0x128()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0806112355v7330ccd4x41e66151f333c144@mail.gmail.com>
References: <5a4c581d0806111506m31412b21lee7bb851dabe6576@mail.gmail.com>
	 <19f34abd0806112355v7330ccd4x41e66151f333c144@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 09:05:06 +0200
Message-Id: <1213254306.31518.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 08:55 +0200, Vegard Nossum wrote:


> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 12 Jun 2008 08:49:18 +0200
> Subject: [PATCH] x86: more hardirq annotations for notify_die()
> 
> Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/kernel/traps_32.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
> index bde6f63..be9ecae 100644
> --- a/arch/x86/kernel/traps_32.c
> +++ b/arch/x86/kernel/traps_32.c
> @@ -569,6 +569,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
>  #define DO_VM86_ERROR(trapnr, signr, str, name)				\
>  void do_##name(struct pt_regs *regs, long error_code)			\
>  {									\
> +	trace_hardirqs_fixup();						\
>  	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
>  						== NOTIFY_STOP)		\
>  		return;							\

Yeah, I think this is ok, actual traps don't have any way of knowing the
actual IRQ state afaik. So

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


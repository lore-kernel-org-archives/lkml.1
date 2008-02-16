Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbYBPT3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbYBPT3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbYBPT3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:29:09 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:45884 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbYBPT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:29:08 -0500
Message-ID: <47B73963.1050702@tiscali.nl>
Date: Sat, 16 Feb 2008 20:28:35 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [x86] arch/x86/kernel/signal_32.c: replace !likely(x)
 by likely(!x)
References: <47B7065B.8090209@tiscali.nl>
In-Reply-To: <47B7065B.8090209@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Replace !likely(x) by likely(!x)
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
> index caee1f0..335872f 100644
> --- a/arch/x86/kernel/signal_32.c
> +++ b/arch/x86/kernel/signal_32.c
> @@ -303,7 +303,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
>  	 * If we are on the alternate signal stack and would overflow it, don't.
>  	 * Return an always-bogus address instead so we will die with SIGSEGV.
>  	 */
> -	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
> +	if (on_sig_stack(sp) && likely(!on_sig_stack(sp - frame_size)))
>  		return (void __user *) -1L;
>  
>  	/* This is the X/Open sanctioned signal stack switching.  */
> --
sorry, please ignore this patch

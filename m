Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbYAJTto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbYAJTto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYAJTth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:49:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYAJTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:49:36 -0500
Message-ID: <478676AE.9000101@zytor.com>
Date: Thu, 10 Jan 2008 11:49:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Use wrmsrl in kprobes.c, step.c
References: <1199949482.19760.9.camel@brick>	 <20080110124041.GA15156@elte.hu> <1199994043.19760.31.camel@brick>
In-Reply-To: <1199994043.19760.31.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Where x86_32 passed zero in the high 32 bits, use wrmsrl which
> will zero extend for us.  This allows ifdefs for 32/64 bit to
> be eliminated.
> 
> Eliminate ifdef in step.c.  Similar cleanup was done when unifying
> kprobes_32|64.c and wrmsr() was chosen there over wrmsrl().  This
> patch changes these to wrmsrl.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/x86/kernel/kprobes.c |    4 ++--
>  arch/x86/kernel/step.c    |    4 ----
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 53ba6a5..34becd1 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -410,13 +410,13 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
>  static void __kprobes clear_btf(void)
>  {
>  	if (test_thread_flag(TIF_DEBUGCTLMSR))
> -		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
> +		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0L);
>  }

Drop the L.  It doesn't buy you anything, and gcc will sign-extend for 
you anyway.  It's just visual clutter.

	-hpa

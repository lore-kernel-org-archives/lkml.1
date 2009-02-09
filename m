Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbZBIRNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbZBIRNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZBIRMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:12:48 -0500
Received: from gw.goop.org ([64.81.55.164]:40896 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbZBIRMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:12:47 -0500
Message-ID: <4990640D.1070701@goop.org>
Date: Mon, 09 Feb 2009 09:12:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 01/11] x86: include correct %gs in a.out core dump
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-2-git-send-email-tj@kernel.org>
In-Reply-To: <1234186798-16820-2-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Impact: dump the correct %gs into a.out core dump
>
> aout_dump_thread() read %gs but didn't include it in core dump.  Fix
> it.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/x86/include/asm/a.out-core.h |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/a.out-core.h b/arch/x86/include/asm/a.out-core.h
> index 3782220..3c601f8 100644
> --- a/arch/x86/include/asm/a.out-core.h
> +++ b/arch/x86/include/asm/a.out-core.h
> @@ -23,8 +23,6 @@
>   */
>  static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
>  {
> -	u16 gs;
> -
>  /* changed the size calculations - should hopefully work better. lbt */
>  	dump->magic = CMAGIC;
>  	dump->start_code = 0;
> @@ -57,7 +55,7 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
>  	dump->regs.ds = (u16)regs->ds;
>  	dump->regs.es = (u16)regs->es;
>  	dump->regs.fs = (u16)regs->fs;
> -	savesegment(gs, gs);
> +	savesegment(gs, dump->regs.gs);
>   
Yes, that looks like a bit of mindless auto-conversion.

Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

    J

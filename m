Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0BVSl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:41:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61869 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0BVSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:41:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eCrGPvpDbBJj7HNL2L/pllj0ZZOA9rgzNyOJPyQq2UUYItmkwGjg5MVS4Ql4gNccvh
         j/C26o3MKKYUkgAYcAbyQtHvKVrZo3TviK6Ot6A0t6kAob2TIj42pLAPcNjgIpM1hzRy
         zr0jipNzDJ+OTfgWV1bTgtgSR1ClCqOfs0+00=
Date: Mon, 22 Feb 2010 19:41:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 02/10] ARM: ftrace: document mcount formats
Message-ID: <20100222184138.GI5055@nowhere>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-3-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266090518-31120-3-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 01:18:30AM +0530, Rabin Vincent wrote:
> Add a comment describing the mcount variants and how the callsites look
> like.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>


Cool, this was really missing I think.


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



> ---
>  arch/arm/kernel/entry-common.S |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 0b042bd..d412d7c 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -92,6 +92,38 @@ ENDPROC(ret_from_fork)
>  #define CALL(x) .long x
>  
>  #ifdef CONFIG_FUNCTION_TRACER
> +/*
> + * When compiling with -pg, gcc inserts a call to the mcount routine at the
> + * start of every function.  In mcount, apart from the function's address (in
> + * lr), we need to get hold of the function's caller's address.
> + *
> + * Older GCCs (pre-4.4) inserted a call to a routine called mcount like this:
> + *
> + *	bl	mcount
> + *
> + * These versions have the limitation that in order for the mcount routine to
> + * be able to determine the function's caller's address, an APCS-style frame
> + * pointer (which is set up with something like the code below) is required.
> + *
> + *	mov     ip, sp
> + *	push    {fp, ip, lr, pc}
> + *	sub     fp, ip, #4
> + *
> + * With EABI, these frame pointers are not available unless -mapcs-frame is
> + * specified, and if building as Thumb-2, not even then.
> + *
> + * Newer GCCs (4.4+) solve this problem by introducing a new version of mcount,
> + * with call sites like:
> + *
> + *	push	{lr}
> + *	bl	__gnu_mcount_nc
> + *
> + * With these compilers, frame pointers are not necessary.
> + *
> + * With both the mcount types, we need to restore the original lr before
> + * returning.  In the __gnu_mcount_nc, version we're allowed to clobber ip.
> + * No other registers should be clobbered.
> + */
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  ENTRY(mcount)
>  	stmdb	sp!, {r0-r3, lr}
> -- 
> 1.6.6
> 


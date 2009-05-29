Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZE2CAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZE2CAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 22:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZE2CAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 22:00:05 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:38677 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZE2CAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 22:00:04 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Futex RFC] was Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Thu, 28 May 2009 21:00:01 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Harald Welte <HaraldWelte@viatech.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905281555.00245.lkml@morethan.org> <200905281815.36728.lkml@morethan.org>
In-Reply-To: <200905281815.36728.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905282100.03577.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu May 28 2009, Michael S. Zick wrote:
> 
> Please, somebody apply an experienced eye-ball to this;
> It does seem to make a difference, but tests have not run
> for very long yet.
> 
> diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
> index 1f11ce4..da3c801 100644
> --- a/arch/x86/include/asm/futex.h
> +++ b/arch/x86/include/asm/futex.h
> @@ -19,7 +19,8 @@
>                      "\t.previous\n"                            \
>                      _ASM_EXTABLE(1b, 3b)                       \
>                      : "=r" (oldval), "=r" (ret), "+m" (*uaddr) \
> -                    : "i" (-EFAULT), "0" (oparg), "1" (0))
> +                    : "i" (-EFAULT), "0" (oparg), "1" (0)      \
> +                    : "memory")
> 
>  #define __futex_atomic_op2(insn, ret, oldval, uaddr, oparg)    \
>         asm volatile("1:\tmovl  %2, %0\n"                       \
> @@ -35,7 +36,8 @@
>                      _ASM_EXTABLE(2b, 4b)                       \
>                      : "=&a" (oldval), "=&r" (ret),             \
>                        "+m" (*uaddr), "=&r" (tem)               \
> -                    : "r" (oparg), "i" (-EFAULT), "1" (0))
> +                    : "r" (oparg), "i" (-EFAULT), "1" (0)      \
> +                    : "memory")
> 
> 
> Mike

Without the above annotations: C7-M/CX700 uptime while running 
pulse-audio: 1 1/2 hrs.

With the above annotations: C7-M/CX700 uptime, same test setup,
maximum unknown, test terminated after 3 hours.

On the C7-M/CN896 - maximum unknown, test terminated after 12 hrs.

Sample build to be available tomorrow.

Mike

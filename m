Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYKZUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYKZUEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYKZUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:04:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38681 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYKZUE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:04:28 -0500
To: gorcunov@gmail.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
From: Andi Kleen <andi@firstfloor.org>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
	<82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
	<cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
Date: Wed, 26 Nov 2008 21:04:33 +0100
In-Reply-To: <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> (gorcunov@gmail.com's message of "Wed, 26 Nov 2008 22:17:01 +0300")
Message-ID: <874p1u45ke.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gorcunov@gmail.com writes:
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -379,7 +379,10 @@ ENTRY(ret_from_fork)
>  	GET_THREAD_INFO(%rcx)
>  	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
>  	CFI_REMEMBER_STATE
> -	jnz rff_trace
> +	jz rff_action
> +	movq %rsp,%rdi
> +	call syscall_trace_leave
> +	GET_THREAD_INFO(%rcx)

The uncommon path is supposed to be out of line. I don't think
the CPU will like that.

-Andi

>  rff_action:

-- 
ak@linux.intel.com

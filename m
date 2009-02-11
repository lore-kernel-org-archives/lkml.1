Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZBKVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZBKVva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbZBKVvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:51:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47819 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbZBKVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:51:09 -0500
Message-ID: <4993483F.8020809@zytor.com>
Date: Wed, 11 Feb 2009 13:50:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: pass in pt_regs pointer for syscalls that need it
 (take 2)
References: <1234277507-4987-3-git-send-email-brgerst@gmail.com> <1234388638-13663-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1234388638-13663-1-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks much better!

Brian Gerst wrote:
>  
>  #ifdef CONFIG_X86_32
> -/*
> - * Note: do not pass in pt_regs directly as with tail-call optimization
> - * GCC will incorrectly stomp on the caller's frame and corrupt user-space
> - * register state:
> - */
> -asmlinkage int sys_rt_sigreturn(unsigned long __unused)
> +int sys_rt_sigreturn(struct pt_regs *regs)
>  {
> -	struct pt_regs *regs = (struct pt_regs *)&__unused;
> -
>  	return do_rt_sigreturn(regs);
>  }
>  #else /* !CONFIG_X86_32 */

I observe with this sys_rt_sigreturn() is identical for both 32 and 64 
bits (since int == long for 32 bits.)  Furthermore, *both* are now no-op 
stubs around do_rt_sigreturn, so we can simply remove both stubs and 
change do_rt_sigreturn into sys_rt_sigreturn.

	-hpa
